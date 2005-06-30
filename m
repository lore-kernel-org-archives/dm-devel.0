From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: mirroring: [patch 5 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 11:38:28 -0500
Message-ID: <200506301138.29354.kevcorry@us.ibm.com>
References: <d459df3fa77e2c972d837f613a137de5@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d459df3fa77e2c972d837f613a137de5@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Kergon Alasdair <agk@redhat.com>
List-Id: dm-devel.ids

Hi Jonathan,

On Thu June 30 2005 3:00 am, Jonathan E Brassow wrote:
> This patch changes the status output.  It will break pvmove and other
> things that may have been parsing the status output of a mirror.

Any time a target's table-format or status-format changes, we also need to 
increment that target's version number so user-space can figure out which 
format to expect.

The version for dm-mirror is currently 1.0.1, so we should at least bump it to 
1.0.2 or 1.1.0.

Also, please remember to turn off line-wrap when inserting patches into 
emails.  :)

Thanks,
-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/


--- dm-raid1.c.old 2005-06-30 11:33:24.000000000 -0500
+++ dm-raid1.c 2005-06-30 11:33:34.000000000 -0500
@@ -1210,7 +1210,7 @@
 
 static struct target_type mirror_target = {
  .name  = "mirror",
- .version = {1, 0, 1},
+ .version = {1, 1, 0},
  .module  = THIS_MODULE,
  .ctr  = mirror_ctr,
  .dtr  = mirror_dtr,
