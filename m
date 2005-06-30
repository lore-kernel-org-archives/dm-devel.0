From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: mirroring: [patch 5 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 14:05:29 -0500
Message-ID: <cf0b6e0fc6f6810b37989e46950fccc8@redhat.com>
References: <d459df3fa77e2c972d837f613a137de5@redhat.com>
	<200506301138.29354.kevcorry@us.ibm.com>
	<20050630175645.GG27078@agk.surrey.redhat.com>
	<81d8053f082764c89f295d2defd3e16c@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: multipart/mixed; boundary=Apple-Mail-3-117208592
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <81d8053f082764c89f295d2defd3e16c@redhat.com>
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
List-Id: dm-devel.ids


--Apple-Mail-3-117208592
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed


On Jun 30, 2005, at 1:10 PM, Jonathan E Brassow wrote:

>
> On Jun 30, 2005, at 12:56 PM, Alasdair G Kergon wrote:
>
>> On Thu, Jun 30, 2005 at 11:38:28AM -0500, Kevin Corry wrote:
>>> Any time a target's table-format or status-format changes, we also 
>>> need to
>>> increment that target's version number so user-space can figure out 
>>> which
>>> format to expect.
>>
>> Indeed, but I don't want version numbers updating till we know what
>> sequence things will go upstream.
>>
>> BTW I've not seen a justification for breaking the existing format 
>> here
>> yet as opposed to simply appending new data to the end of the status 
>> line.
>>
>
> mirror_status first calls the log status function and then adds on to 
> that.  If we want to do what you are proposing, we would move the log 
> status function _after_ the DMEMIT's for mirror and it would only 
> print out a char for each log device indicating status.  We would have 
> to remember that STATUSTYPE_INFO and STATUSTYPE_TABLE would call the 
> log status function at different place (one after it's own DMEMITs, 
> the other before).
>

Perhaps like the attached patch.

I think the pvmove stuff is already busted.  How does it handle mirrors 
with more than 2 sides?  (ok, so pvmove isn't broken, but code that 
uses the same function to determine a mirrors status would be - lvs?)  
If we are going to add code that must correctly handle the number of 
mirror args, I think we could add code to properly handle the log args 
at the same time.  Then we have some (limited) flexibility in how 
things are handled.

  brassow


--Apple-Mail-3-117208592
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream; x-unix-mode=0664;
	name="00005-alt.patch"
Content-Disposition: attachment;
	filename=00005-alt.patch

diff -urN linux-2.6.12-00004/drivers/md/dm-log.c linux-2.6.12-00005-alt/drivers/md/dm-log.c
--- linux-2.6.12-00004/drivers/md/dm-log.c	2005-06-30 01:44:58.000000000 -0500
+++ linux-2.6.12-00005-alt/drivers/md/dm-log.c	2005-06-30 13:46:43.260023309 -0500
@@ -737,6 +737,8 @@
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		format_dev_t(buffer, lc->log_dev->bdev->bd_dev);
+		DMEMIT("%s %c", buffer, lc->log_dev_failed ? 'D' : 'A');
 		break;
 
 	case STATUSTYPE_TABLE:
diff -urN linux-2.6.12-00004/drivers/md/dm-raid1.c linux-2.6.12-00005-alt/drivers/md/dm-raid1.c
--- linux-2.6.12-00004/drivers/md/dm-raid1.c	2005-06-30 01:56:19.000000000 -0500
+++ linux-2.6.12-00005-alt/drivers/md/dm-raid1.c	2005-06-30 13:55:18.644187058 -0500
@@ -1538,23 +1538,28 @@
 static int mirror_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
-	unsigned int m, sz;
+	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
-
-	sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+	char buffer[ms->nr_mirrors + 1];
 
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%d ", ms->nr_mirrors);
-		for (m = 0; m < ms->nr_mirrors; m++)
+		for (m = 0; m < ms->nr_mirrors; m++) {
 			DMEMIT("%s ", ms->mirror[m].dev->name);
+			buffer[m] = atomic_read(&(ms->mirror[m].error_count)) ? 
+				'D' : 'A';
+		}
+		buffer[m] = '\0';
 
-		DMEMIT(SECTOR_FORMAT "/" SECTOR_FORMAT,
+		DMEMIT(SECTOR_FORMAT "/" SECTOR_FORMAT " %s ",
 		       ms->rh.log->type->get_sync_count(ms->rh.log),
-		       ms->nr_regions);
+		       ms->nr_regions, buffer);
+		ms->rh.log->type->status(ms->rh.log, type, result+sz, maxlen-sz);
 		break;
 
 	case STATUSTYPE_TABLE:
+		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
 		DMEMIT("%d ", ms->nr_mirrors);
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT("%s " SECTOR_FORMAT " ",

--Apple-Mail-3-117208592
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed



--Apple-Mail-3-117208592
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Apple-Mail-3-117208592--
