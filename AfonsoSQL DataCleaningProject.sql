Select *
From PorfolioProject1..NashvilleHousing


Select SaleDateConverted, CONVERT(date,SaleDate)
From PorfolioProject1..NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


Select *
From PorfolioProject1..NashvilleHousing
--Where PropertyAddress is NULL
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PorfolioProject1..NashvilleHousing a
JOIN PorfolioProject1..NashvilleHousing b
        ON a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL


Update a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PorfolioProject1.dbo.NashvilleHousing a
JOIN PorfolioProject1.dbo.NashvilleHousing b
        On a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null





  

--Breaking out Address into Individual colums(Address, City, State)



Select PropertyAddress
From PorfolioProject1.dbo.NashvilleHousing
Where PropertyAddress is null
Order by ParcelID


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

From PorfolioProject1.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing 
Add PropertySplitAddress Nvarchar(255);


Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))





Select *
From PorfolioProject1.dbo.NashvilleHousing





Select OwnerAddress
From PorfolioProject1.dbo.NashvilleHousing



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PorfolioProject1.dbo.NashvilleHousing




ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)




ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)




ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PorfolioProject1.dbo.NashvilleHousing










Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PorfolioProject1.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'y' THEN 'YES'
           When SoldAsVacant = 'N' THEN 'NO'
		   ELSE SoldAsVacant
		   END
From PorfolioProject1.dbo.NashvilleHousing




Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'y' THEN 'YES'
           When SoldAsVacant = 'N' THEN 'NO'
		   ELSE SoldAsVacant
		   END









WITH RowNumCTE AS(
Select *,
        ROW_NUMBER() OVER (
		PARTITION BY ParcelID, 
		                         PropertyAddress,
								 SalePrice,
								 SaleDate,
								 LegalReference
								 ORDER BY 
								        UniqueID
										) row_num

From PorfolioProject1.dbo.NashvilleHousing
--Order by ParcelId
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PorfolioProject1.dbo.NashvilleHousing






Select *
From PorfolioProject1.dbo.NashvilleHousing



ALTER TABLE PorfolioProject1.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate












Importing Data using OPENROWSET and BULK INSERT


More advanced and looks cooler, but have to cinfigure server appropriately to do correctly
Wanted to provide this in case you wanted to try it



sp_configure 'show advanced options' , 1;
RECONFIGURE;
GO
sp_configure 'Ad hoc Distributed Queries' 1;
RECONFIGURE;
GO



USE PorfolioProject1


GO


EXEC master.dbo.sp_MSet_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'AllowInProcess' , 1


GO


EXEC master.dbo.sp_MSet_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'DynamicParameters' , 1



GO



Using Bulk INSERT



USE PorfolioProject1;
GO
BULK INSERT nashvillehousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
   With (
      FIELDTERMMINATOR = ',',
	  ROWTERMINATOR = '\N'
);
GO



     Using OPENROWSET
USE PorfolioProject1;
GO
SELECT * INTO nashvillehousing
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0' ,
    'Excel 12.0; Database=C:\Users\Afonso\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data Cleaning Project.csv' , [Sheet1$]);
Go 








