From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 6/8] [persistent-data] Add a
	transactional	array.
Date: Tue, 22 Jan 2013 21:18:51 +0000
Message-ID: <20130122211851.GB30267@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-7-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1355429956-22785-7-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Reading first only the interface file (all-caches version), I'm left
with the following questions about how to use the interface: please
would you try to update the comments so they answer the questions?

Thanks,
Alasdair


--- /dev/null
+++ linux/drivers/md/persistent-data/dm-array.h
@@ -0,0 +1,128 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ *
+ * This file is released under the GPL.
+ */
+#ifndef _LINUX_DM_ARRAY_H
+#define _LINUX_DM_ARRAY_H
+
+#include "dm-btree.h"
+
+/*----------------------------------------------------------------*/
+
+/*
+ * The dm-array is a persistent version of an array.  It packs the data

What sort of array?

+ * more efficiently than a btree which will result in less disk space use,
+ * and a performance boost.  The get and set operations are still O(ln(n)),
+ * but with a much smaller constant.
+ *
+ * The value type structure is reused from the btree type to support proper
+ * reference counting of values.
+ *
+ * The arrays implicitly know their length, and bounds are checked for
+ * lookups and updates.  It doesn't store this in an accessible place
+ * because it would waste a whole metadata block.  Make sure you store the
+ * size along with the array root in your encompassing data.
+ */

How are array entries indexed?
Consecutive integers?  Starting from 0 or 1?
Or can arrays be sparse, with the 'size' being the number of populated
entries?

+/*
+ * Describes an array.  Don't initialise this structure yourself, use the
+ * setup function below.
+ */
+struct dm_array_info {
+	struct dm_transaction_manager *tm;
+	struct dm_btree_value_type value_type;
+	struct dm_btree_info btree_info;
+};

What is the normal way to initialise an array of a specific size
(that it says the caller must track)?
What error do I get if I try to add an element that would take it
beyond the size the array is defined to have?

+/*
+ * Sets up a dm_array_info structure.
+ *
+ * info - the structure being filled in.
+ * tm   - the transaction manager that should supervise this structure.
+ * vt   - describes the leaf values.
+ */
+void dm_setup_array_info(struct dm_array_info *info,
+			 struct dm_transaction_manager *tm,
+			 struct dm_btree_value_type *vt);
+
+/*
+ * Initialise an empty array, zero length array.
+ *
+ * info - describes the array

Must this be populated first by calling dm_array_info() ?

+ * root - on success this will be filled out with the root block

And must this root block then be passed into all the functions
that manipulate the array?

The description of dm_btree_empty() in dm-btree.h is that
that function does 'Set up' and it's clearly paired with dm_btree_del().

Is there a counterpart to dm_setup_array_info if I want to
destroy it or isn't one needed?

Is this similar to what dm_bitset_info_init() is doing and would
an _init suffix instead of 'setup' be clearer here too?

+ */
+int dm_array_empty(struct dm_array_info *info, dm_block_t *root);

Is it compulsory to call this function after calling dm_setup_array_info()?
[Otherwise I wouldn't have a 'root' I can use?]

But if so, how do I set the actual length of the array I want to use
(which it says I must keep track myself)?
Am I required also to call dm_array_resize() afterwards with an
old_size of 0 because an array with a size of 0 would otherwise
be useless to me?

If I call this on an existing populated array will it 'empty' it
correctly like the name suggests or shouldn't that be done?

+/*
+ * Resizes the array.
+ *
+ * info - describes the array
+ * root - the root block of the array on disk
+ * old_size - yes, the caller is responsible for remembering the size of the array
+ * new_size - can be bigger or smaller than old_size
+ * value - if we're growing the array the new entries will have this value
+ * new_root - on success, points to the new root block
+ *
+ * If growing the inc function for value will be called the appropriate
+ * number of times.  So if the caller is holding a reference they may want
+ * to drop it.
+ */
+int dm_array_resize(struct dm_array_info *info, dm_block_t root,
+		    uint32_t old_size, uint32_t new_size,
+		    const void *value, dm_block_t *new_root)
+	__dm_written_to_disk(value);

If it gives me 'new_root' does that mean I must replace my copy of
'root' with it and does the old 'root' remain valid in any way or not?

+/*
+ * Frees a whole array.  The value_type's decrement operation will be called
+ * for all values in the array
+ */
+int dm_array_del(struct dm_array_info *info, dm_block_t root);

Does anything remain valid after calling this?
- Is root no longer valid?
- Without touching 'info', can I call dm_array_empty() again at this
  point?

+/*
+ * Lookup a value in the array
+ *
+ * info - describes the array
+ * root - root block of the array
+ * index - array index
+ * value - the value to be read.  Will be in on disk format of course.
+ *
+ * -ENODATA will be returned if the index is out of bounds.
+ */
+int dm_array_get(struct dm_array_info *info, dm_block_t root,
+		 uint32_t index, void *value);

Is this like dm_get() ?
In what sense does dm_array_get get a dm_array?
- get_value?  lookup?

+/*
+ * Set an entry in the array.
+ *
+ * info - describes the array
+ * root - root block of the array
+ * index - array index
+ * value - value to be written to disk.  Make sure you bless this before
+ *         calling.

How do I 'bless this'?
Must 'value' conform to the definition in info->value_type?

+ * new_root - the new root block
+ *
+ * The old value being overwritten will be decremented, the new value
+ * incremented.
+ *
+ * -ENODATA will be returned if the index is out of bounds.
+ */
+int dm_array_set(struct dm_array_info *info, dm_block_t root,
+		 uint32_t index, const void *value, dm_block_t *new_root)
+	__dm_written_to_disk(value);

Define dm_array_set before dm_array_get in this file, perhaps?

set_value?  store?  rather then implying it's setting the whole array?

What am I supposed to do with 'new_root'?  Does 'root' become invalid?
Perhaps a general comment at the top about root and new_root would 
be a good way to explain.

+/*
+ * Walk through all the entries in an array.
+ *
+ * info - describes the array
+ * root - root block of the array
+ * fn - called back for every element
+ * context - passed to the callback
+ */
+int dm_array_walk(struct dm_array_info *info, dm_block_t root,
+		  int (*fn)(void *, uint64_t key, void *leaf),

Make that 'void *context' so it's more obvious where it comes from?

+		  void *context);
+
+/*----------------------------------------------------------------*/
+
+#endif
