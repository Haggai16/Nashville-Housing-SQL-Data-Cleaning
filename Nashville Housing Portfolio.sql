/* 
Cleaning Data in SQL Queries
*/

Select *
From PortfolioPROJECT..Nashvillehousing

-----------------------------------------------------------

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioPROJECT..Nashvillehousing

update Nashvillehousing
SET.SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashvillehousing
Add SaleDateConverted Date;

update Nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------

--Populate Property Address Data

Select *
From PortfolioPROJECT..Nashvillehousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioPROJECT..Nashvillehousing a
JOIN PortfolioPROJECT..Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.Propertyaddress,b.PropertyAddress)
From PortfolioPROJECT..Nashvillehousing a
JOIN PortfolioPROJECT..Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 

----------------------------------------------------------------------------------

--Breaking out Address Into Individual columns (Address, City, State)

Select PropertyAddress
From PortfolioPROJECT..Nashvillehousing
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

From PortfolioPROJECT..Nashvillehousing

ALTER TABLE Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

update Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE Nashvillehousing
Add PropertySplitCity Nvarchar(255);

update Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select *
From PortfolioPROJECT..Nashvillehousing


Select OwnerAddress
From PortfolioPROJECT..Nashvillehousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioPROJECT..Nashvillehousing


ALTER TABLE Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

update Nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE Nashvillehousing
Add OwnerSplitCity Nvarchar(255);

update Nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE Nashvillehousing
Add OwnerSplitState Nvarchar(255);

update Nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


Select*
From PortfolioPROJECT..Nashvillehousing

---------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PortfolioPROJECT..Nashvillehousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From PortfolioPROJECT..Nashvillehousing

update Nashvillehousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
					UniqueID
					) row_num

From PortfolioPROJECT..Nashvillehousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--order by PropertyAddress



----------------------------------------------------------------------------------------

--Delete Unused Columns

Select *
From PortfolioPROJECT..Nashvillehousing

ALTER TABLE PortfolioPROJECT..Nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioPROJECT..Nashvillehousing
DROP COLUMN SaleDate