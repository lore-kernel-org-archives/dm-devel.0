From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: [RFC] Change to the mirror table map
Date: Fri, 20 Oct 2006 14:36:54 -0500
Message-ID: <c333ab79987a0006c182eb7d041e3fc7@redhat.com>
References: <OF75AC1D80.D78E8F6A-ONC125720D.005489B7-C125720D.0059457E@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: multipart/mixed; boundary=Apple-Mail-9-529704404
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF75AC1D80.D78E8F6A-ONC125720D.005489B7-C125720D.0059457E@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com
List-Id: dm-devel.ids


--Apple-Mail-9-529704404
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed


On Oct 20, 2006, at 11:18 AM, Stefan Bader wrote:

> Hi Jonathan,
>
>
>> New features:
>>
>> I've added a format argument ("format2" in example).  It is always 
>> the first
>> argument to the mirror target.  If it isn't present, we can assume
>> the original
>> format.  If it is present, we can use the format specified.
>>
> Probably isn't needed with section keywords. Something not "core" or
> "disk" is format2.

or "clustered_disk" or "clustered_core" or any other logging 
implementation that we may develop in the future, like "multi_disk".  
The problem is, then we need to either encode all those in the 
mirror_ctr or wait for 'create_dirty_log' to return NULL - then pass on 
to the second format, which may also return an error.

And if we again decide to change the format in the future...

With the format argument, we don't need the extra logic.  We simply 
pass on the rest to the correct constructor function for that format.

>> The mapping table is broken up into sections.  The sections are 
>> allowed to be
>> in any order, and we should be able to add sections in the future if
>> necessary.
>>
> From the user side good since it allows more flexibility. The downside 
> is it adds complexity to the kernel parsing. And there might be 
> sections that depend on each other...

That's why the section identifier is there.  We can identify the 
sections and reorder them as we construct the mirror.  If we add new 
sections in the future that we may want decoded before some sections 
but after others, we don't need to worry about were they are placed in 
the table line.

Additionally, since we know the number of arguments, it is easy to 
identify sections and their arguments and pass them on to other 
functions that further break them down.

Attached, please find an example of how the new constructor might look.

>
>> The devices section starts with the keyword 'devices' and is followed 
>> by the
>> number of devices then the number of per device arguments.  This is 
>> not
>> consistent with the other sections.  It may be better to have the 
>> keyword
>> followed by the argument count, followed by the per device argument 
>> count.
>> Something like:
>>     devices 5 1 253:3 S 253:4 A
>> or
>>     devices 5 2 253:3 S 253:4 A
>>
> Or something like
>         devices 2 2 543:3 S 2 253:4 A
> so each device can have a different number of arguments?
>
>> depending on if you want to include the device in the per device 
>> argument
>> count.  Notice that I have done away with the 'offset' parameter 
>> found in
>> the original.  Multipath doesn't have that, and neither does mirroring
>> when specifying the log device.  For the above example, I did add an
>>
> Personally I think the offset is useful if doing mappings for complete
> partitions/disks and the log should rather have it as well.

For simplicity, I've kept the offset (pvmove uses it), removed the 
status arg, and made the section argument count consistent.  I now 
think it should look something like:
     devices 4 253:3 0 253:4 0
(The example patch expects this.)

>> The read balancing section starts with the keyword 'read-balance' and 
>> is
>> followed by the number of read balancing arguments.  After that, it is
>> just like multipathing.  If we were certain that the devices section 
>> did
>> not need any device specific arguments, we could combine the devices 
>> section
>> and the read-balance section.  (This could be the case if we decided 
>> to
>> add a section for initial device status and didn't need the offset 
>> argument.)
>> Mirror does need to keep it's own list of devices, however; and it 
>> might be
>> nice to be able to parse that section separate - rather than parse the
>> read-balancing section twice.
>>
> I don't know if this can be solved in a nice way without completely
> changing the way the layout is today. :/ I undestand why going this 
> way but it
> feels a bit ugly to have the same device specification twice. If there 
> would be
> something like
>         devices 2 2 253:3 rr_min=1000 3 253:4 mstate=m rr_min=1000
> every per device option would be in one place. But parsing would have 
> to
> be done more than once...

I agree that having to state a device multiple times is ugly.  However, 
I don't like parsing sections multiple times for different things.  I'd 
really like to have a 'section to function' mapping if possible.  
Additionally, we can't be sure what extra information (sections) we may 
add in the future.  (Think device status, or other).  That could be 
solved by your solution above and would simply change the per device 
argument count; but again, I'd like to avoid parsing the same section 
multiple times - or mangling the order of parameters to much just to 
pass them to say, the path selector constructor for read balancing.)

>
>> Multipath takes the approach of having positional arguments (e.g. the 
>> 'number
>> of features' argument is in a known place).  If we took this 
>> approach, we
>> could eliminate the keywords.  However, I think I prefer the ability 
>> to
>> identify sections.
>>
> It makes identification of section simpler to parse by the human reader
> which
> I like as well. ;-)
>
> Stefan
>

Thank-you for your comments Stefan.  Below is a quick patch of how I 
would see the code changes for the constructor.  (I didn't put in the 
per-section functions.  Nor did I put in the read balancing stuff yet.  
This is just an example of how to make the constructor more flexible... 
paving the way for read balancing.)

  brassow


--Apple-Mail-9-529704404
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream; x-unix-mode=0664;
	name="mirror_table_change.patch"
Content-Disposition: attachment;
	filename=mirror_table_change.patch

Index: linux-2.6.18/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.18.orig/drivers/md/dm-raid1.c	2006-10-20 10:39:24.000000000 -0500
+++ linux-2.6.18/drivers/md/dm-raid1.c	2006-10-20 13:54:55.000000000 -0500
@@ -1016,13 +1016,137 @@ static struct dirty_log *create_dirty_lo
 }
 
 /*
- * Construct a mirror mapping:
+ * mirror_format2_ctr
+ * @ti
+ * @argc
+ * @argv
  *
- * log_type #log_params <log_params>
- * #mirrors [mirror_path offset]{2,}
+ * Format2:
+ *   format2 \
+ *   log <#log_params> <log_params> \
+ *   devices <#dev_params> <device1> <offset1> ... <deviceN> <offsetN>
+ * Example:
+ *   format2 log 4 disk 253:2 1024 block_on_error devices 2 253:3 0 253:4 0
  *
- * log_type is "core" or "disk"
- * #log_params is between 1 and 3
+ * Format2 allows for new sections, as well as for the sections to
+ * be in any order.
+ *
+ * Returns: 0 on success, -EXXX on failure
+ */
+static int mirror_format2_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	unsigned int log_argc, devices_argc, section_argc;
+	char **log_argv, **devices_argv, *section_id;
+	struct dirty_log *dl;
+	unsigned int nr_mirrors, m;
+
+	argv++; /* skip over "format2" arg */
+	argc--;
+
+	/* Identify the sections */
+	while (argc) {
+		section_id = argv[0];
+
+		/* FIXME: Break this down for better error reporting? */
+		if ((argc < 2) ||
+		    (sscanf(argv[1], "%u", &section_argc) != 1) ||
+		    (section_argc > (argc - 2))) {
+			ti->error = "Invalid mirror mapping table";
+			return -EINVAL;
+		} else {
+			argc -= 2;
+			argv += 2;
+		}
+
+		if (!strcmp("log", section_id)) {
+			log_argv = argv;
+			log_argc = section_argc;
+		} else if (!strcmp("devices", section_id)) {
+			devices_argv = argv;
+			devices_argc = section_argc;
+		} else {
+			ti->error = "Unknown section in mirror mapping table";
+			return -EINVAL;
+		}
+		argc -= section_argc;
+		argv += section_argc;
+	}
+
+	/* Construct mirror - could make each section a separate function */
+	if (log_argc < 2) {
+		ti->error = "Insufficient mirror log arguments";
+		return -EINVAL;;
+	}
+	dl = dm_create_dirty_log(log_argv[0], ti, log_argc - 1, log_argv + 1);
+	if (!dl) {
+		ti->error = "Error creating mirror dirty log";
+		return -EINVAL;
+	}
+
+	if (!_check_region_size(ti, dl->type->get_region_size(dl))) {
+		ti->error = "Invalid region size";
+		dm_destroy_dirty_log(dl);
+		return -EINVAL;
+	}
+
+	/*
+	 * Right now, devices_argc is equal to 1/2 the number of mirror
+	 * devices specified.  However, this could change in the
+	 * future depending on feedback from other developers.
+	 */
+	nr_mirrors = devices_argc/2;
+
+	if ((nr_mirrors < 2) || (nr_mirrors > KCOPYD_MAX_REGIONS + 1)) {
+		ti->error = "Invalid number of mirrors";
+		dm_destroy_dirty_log(dl);
+		return -EINVAL;
+	}
+
+	ms = alloc_context(nr_mirrors, dl->type->get_region_size(dl), ti, dl);
+	if (!ms) {
+		dm_destroy_dirty_log(dl);
+		return -ENOMEM;
+	}
+
+	/* Get the mirror parameter sets */
+	for (m = 0; m < nr_mirrors; m++) {
+		r = get_mirror(ms, ti, m, devices_argv + (2 * m));
+		if (r) {
+			free_context(ms, ti, m);
+			return r;
+		}
+	}
+
+	ti->private = ms;
+ 	ti->split_io = ms->rh.region_size;
+
+	r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
+	if (r) {
+		free_context(ms, ti, ms->nr_mirrors);
+		return r;
+	}
+
+	add_mirror_set(ms);
+	return 0;
+}
+
+/*
+ * mirror_ctr
+ * @ti
+ * @argc
+ * @argv
+ *
+ * This function constructs the mirror map given the mapping
+ * table found in argv.  If the first argument is 'format2',
+ * 'mirror_format2_ctr is used; otherwise, the following is
+ * the valid argument set:
+ *   <log_type> <#log_params> <log_params> \
+ *   <#mirrors> <device1> <offset1> ... <deviceN> <offsetN>
+ *
+ * See the log_type implementations for details on their
+ * argument list.
+ *
+ * Returns: 0 on success, -EXXX on failure
  */
 #define DM_IO_PAGES 64
 static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
@@ -1032,6 +1156,9 @@ static int mirror_ctr(struct dm_target *
 	struct mirror_set *ms;
 	struct dirty_log *dl;
 
+	if (!strcmp("format2", argv[0]))
+		return mirror_format2_ctr(ti, argc, argv);
+
 	dl = create_dirty_log(ti, argc, argv, &args_used);
 	if (!dl)
 		return -EINVAL;

--Apple-Mail-9-529704404
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed



--Apple-Mail-9-529704404
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Apple-Mail-9-529704404--
