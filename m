From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-emc hardware handler patches
Date: Wed, 6 Dec 2006 22:06:02 +0000
Message-ID: <20061206220602.GI4409@agk.surrey.redhat.com>
References: <6CCEAEDF4D06984A83F427424F47D6E4028D05FF@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4028D05FF@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com, michaelc@cs.wisc.edu
List-Id: dm-devel.ids

On Tue, Dec 05, 2006 at 03:42:41PM -0500, goggin, edward wrote:
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -627,6 +627,7 @@ static int parse_hw_handler(struct arg_s
>  	struct hw_handler_type *hwht;
>  	unsigned hw_argc;
>  	struct dm_target *ti = m->ti;
> +	struct mapped_device *md;
>  
>  	static struct param _params[] = {
>  		{0, 1024, "invalid number of hardware handler args"},


How about this instead?

--- linux-2.6.19.orig/drivers/md/dm-hw-handler.h	2006-12-06 20:49:24.000000000 +0000
+++ linux-2.6.19/drivers/md/dm-hw-handler.h	2006-12-06 21:18:46.000000000 +0000
@@ -16,6 +16,7 @@
 struct hw_handler_type;
 struct hw_handler {
 	struct hw_handler_type *type;
+	struct mapped_device *md;
 	void *context;
 };
 

Then each hw-handler wouldn't need its own code to store it and
we'd just have:

--- linux-2.6.19.orig/drivers/md/dm-mpath.c	2006-12-06 20:55:37.000000000 +0000
+++ linux-2.6.19/drivers/md/dm-mpath.c	2006-12-06 21:35:09.000000000 +0000
@@ -666,6 +666,9 @@ static int parse_hw_handler(struct arg_s
 		return -EINVAL;
 	}
 
+	m->hw_handler.md = dm_table_get_md(ti->table);
+	dm_put(m->hw_handler.md);
+
 	r = hwht->create(&m->hw_handler, hw_argc - 1, as->argv);
 	if (r) {
 		dm_put_hw_handler(hwht);



> +	/*
> +	 * No need to hold a reference on the mapped device here
> +	 * since one is already held for the duration of the
> +	 * mapped device open.
> +	 */

I think it's stronger than that: a (self-)reference must not be held here,
or how would the reference count ever subsequently drop to zero?

Makes you wonder in what circumstances the dm_get() in dm_table_get_md()
is ever required.

Alasdair
-- 
agk@redhat.com
