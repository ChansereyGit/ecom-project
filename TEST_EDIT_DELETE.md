# Test Edit & Delete Functionality

## Quick Test Guide

### Prerequisites
1. Backend running on `http://localhost:8080`
2. Admin portal running on `http://localhost:5174`
3. Logged in as admin user
4. At least one hotel with rooms in the database

## Test 1: Edit Hotel Information

1. **Navigate to Properties**
   - Click "Properties" in sidebar
   - Select any hotel from the list

2. **Enter Edit Mode**
   - Click "Edit" button (top right)
   - Verify all fields become editable
   - Button changes to "Cancel" and "Save Changes" appears

3. **Make Changes**
   - Change hotel name (e.g., add "Updated" to the name)
   - Change status from "Active" to "Maintenance"
   - Update phone number
   - Modify check-in time

4. **Save Changes**
   - Click "Save Changes" button
   - Wait for success message
   - Verify button changes back to "Edit"
   - Check property list shows updated name
   - Check status badge shows orange "Maintenance"

5. **Verify Persistence**
   - Refresh the page (F5)
   - Select the same hotel
   - Verify all changes are still there

**Expected Result:** ✅ All changes saved and persist after refresh

## Test 2: Cancel Edit Without Saving

1. **Enter Edit Mode**
   - Click "Edit" button
   - Make some changes to fields

2. **Cancel**
   - Click "Cancel" button
   - Verify fields revert to original values
   - Verify edit mode exits

**Expected Result:** ✅ Changes discarded, original data restored

## Test 3: Delete Hotel

1. **Select Hotel to Delete**
   - Choose a test hotel (not important data)
   - Note the hotel name

2. **Delete**
   - Click "Delete" button (top right)
   - Confirm in dialog

3. **Verify Deletion**
   - Hotel disappears from property list
   - Next hotel is auto-selected
   - Success message appears

4. **Verify in Database** (Optional)
   ```sql
   SELECT * FROM hotels WHERE name = 'Deleted Hotel Name';
   -- Should return no results
   ```

**Expected Result:** ✅ Hotel deleted, list updates, next hotel selected

## Test 4: Add New Room

1. **Go to Room Types Tab**
   - Select a hotel
   - Click "Room Types" tab
   - Click "Add Room Type" button

2. **Fill Form**
   - Room Type: "Test Suite"
   - Price: 250
   - Bed Type: "King"
   - Max Guests: 2
   - Total Rooms: 5
   - Available Rooms: 5
   - Add 1-2 image URLs
   - Select 3-4 amenities
   - Check "Includes Breakfast"

3. **Submit**
   - Click "Add Room Type"
   - Wait for success message
   - Modal closes

4. **Verify**
   - New room appears in the list
   - All details are correct
   - Image displays properly
   - Amenities show correctly

**Expected Result:** ✅ Room created and appears in list

## Test 5: Edit Room

1. **Find Room to Edit**
   - Go to Room Types tab
   - Find the "Test Suite" room created above
   - Click "Edit" button

2. **Make Changes**
   - Change price to 275
   - Add another amenity
   - Change available rooms to 4
   - Add another image URL

3. **Save**
   - Click "Update Room"
   - Wait for success message
   - Modal closes

4. **Verify**
   - Room card shows new price ($275)
   - Available rooms shows 4
   - New amenity appears
   - New image is in gallery

**Expected Result:** ✅ Room updated with new values

## Test 6: Delete Room

1. **Find Room to Delete**
   - Go to Room Types tab
   - Find the "Test Suite" room
   - Click "Delete" button

2. **Confirm**
   - Confirm in dialog
   - Wait for success message

3. **Verify**
   - Room disappears from list
   - Other rooms remain unchanged

**Expected Result:** ✅ Room deleted, list updates

## Test 7: Edit Room Images

1. **Open Edit Modal**
   - Click "Edit" on any room
   - Scroll to "Room Images" section

2. **Add Images**
   - Add 3 sample Unsplash URLs:
     - `https://images.unsplash.com/photo-1611892440504-42a792e24d32`
     - `https://images.unsplash.com/photo-1618773928121-c32242e63f39`
     - `https://images.unsplash.com/photo-1582719478250-c89cae4dc85b`
   - Click "Add" for each

3. **Remove Image**
   - Click "Remove" on one image
   - Verify it's removed from list

4. **Save**
   - Click "Update Room"
   - Verify room card shows first image
   - Verify "+2 more" badge appears

**Expected Result:** ✅ Images added/removed correctly

## Test 8: Edit Room Amenities

1. **Open Edit Modal**
   - Click "Edit" on any room
   - Scroll to "Room Amenities"

2. **Toggle Amenities**
   - Check 5 amenities
   - Uncheck 2 amenities
   - Note which ones are selected

3. **Save**
   - Click "Update Room"
   - Verify room card shows first 3 amenities
   - Verify "+X more" count is correct

**Expected Result:** ✅ Amenities updated correctly

## Test 9: Validation Errors

1. **Try Invalid Price**
   - Edit a room
   - Set price to 0 or negative
   - Try to save
   - Verify error message appears

2. **Try Empty Required Fields**
   - Clear room type
   - Try to save
   - Verify error message appears

3. **Try Invalid Inventory**
   - Set available rooms > total rooms
   - Try to save
   - Verify error message appears

**Expected Result:** ✅ Validation prevents invalid data

## Test 10: Concurrent Edits

1. **Open Two Browser Tabs**
   - Tab 1: Edit a hotel
   - Tab 2: View same hotel

2. **Save in Tab 1**
   - Make changes in Tab 1
   - Save changes

3. **Refresh Tab 2**
   - Refresh Tab 2
   - Verify changes appear

**Expected Result:** ✅ Changes sync across tabs after refresh

## Common Issues & Solutions

### Issue: "Failed to save changes"
- **Check:** Backend is running
- **Check:** JWT token is valid (try logging out and back in)
- **Check:** Network tab in browser DevTools for error details

### Issue: Changes don't persist
- **Check:** Success message appeared
- **Check:** No console errors
- **Check:** Database connection is working

### Issue: Delete button doesn't work
- **Check:** Confirmation dialog appears
- **Check:** You clicked "OK" in the dialog
- **Check:** Backend logs for errors

### Issue: Room images don't display
- **Check:** Image URLs are valid and publicly accessible
- **Check:** URLs start with `http://` or `https://`
- **Check:** Browser console for CORS errors

## Success Criteria

All tests should pass with:
- ✅ No console errors
- ✅ Success messages appear
- ✅ Data persists after refresh
- ✅ UI updates immediately
- ✅ Validation works correctly
- ✅ Confirmation dialogs appear
- ✅ Loading states show during operations
