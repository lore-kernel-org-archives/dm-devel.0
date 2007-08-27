From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: dm-rdac not working?
Date: Mon, 27 Aug 2007 14:26:05 -0700
Message-ID: <1188249965.9504.45.camel@linuxchandra>
References: <46D2E298.1020702@linpro.no>
	<1188236026.9504.10.camel@linuxchandra>  <46D3188A.3090405@linpro.no>
	<1188245328.9504.41.camel@linuxchandra>  <46D33BAA.8090807@linpro.no>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-KOyP5zrHwHNXVKmS9D+g"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46D33BAA.8090807@linpro.no>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tore Anderson <tore@linpro.no>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--=-KOyP5zrHwHNXVKmS9D+g
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-08-27 at 23:01 +0200, Tore Anderson wrote:
> * Chandra Seetharaman
> 
> > tur checker just sends a test unit ready to see if the path is good. 
> > Whereas rdac sends a c9 page inquiry and determines the state of the 
> > path.
> 
>    Okay.  I'm not really sure if I understand what practical difference
>   there is between the two, though...  The TUR check seems to fail like
>   it's supposed to if the path goes bad.

In RDAC mode, tur will always fail on the passive path. You do not see
that ?

> 
> > That is true. But, I am wondering if what you have is based on the
> > LSI Engenio based controller (and hence the controller does not
> > understand the MODE_SELECT command).
> 
>    It's an Engenio 3994 that came with a sticker on it that says Sun
>   StorageTek 6140.
> 
> > What mode do you have your storage device configured in ? rdac or AVT
> > ?
> 
>    Host-type "Linux", which means RDAC (AVT is mostly unusable for
>   clusters because of all the unwanted volume transfers it causes).  It's
>   supposed to be used with LSI's RDAC 09.01.B2.xx driver, but that one
>   doesn't work with recent kernels unfortunately.
> 
> > Where did you get mpath_prio_rdac from ?
> > 
> > In 0.4.7 you could use mpath_prio_tpc instead (it behaves exactly as 
> > mpath_prio_rdac in 0.4.8).
> 
>    I got it from the 0.4.8 sources - mpath_prio_tpc complained a lot
>   about AVT mode being disabled, which screwed up my multipath -ll output
>   so I just got the new version instead.

You mean mpath_prio_tpc from 0.4.7 ? I use it all the time in both RDAC
and AVT mode with no issues.

> 
> > Can you apply the attached debug patch, repeat your test and send me
> > the log.
> 
>    Sure, but I think you forgot to actually attach the patch... (Happens
>   to me too all the time!)

oops :)... attached
> 
> Regards
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


--=-KOyP5zrHwHNXVKmS9D+g
Content-Disposition: attachment; filename=debug
Content-Type: text/x-patch; name=debug; charset=utf-8
Content-Transfer-Encoding: 7bit

Index: linux-2.6.22/drivers/md/dm-mpath-rdac.c
===================================================================
--- linux-2.6.22.orig/drivers/md/dm-mpath-rdac.c
+++ linux-2.6.22/drivers/md/dm-mpath-rdac.c
@@ -229,6 +229,13 @@ static void mode_select_endio(struct req
 	struct scsi_sense_hdr sense_hdr;
 	int sense = 0, fail = 0;
 
+	DMINFO("MODE_SELECT of %s returned error %d; host_byte 0x%x, "
+		"msg_byte 0x%x, status_byte 0x%x\n",
+		h->path->dev->name, error,
+		host_byte(req->errors),
+		msg_byte(req->errors),
+		status_byte(req->errors));
+
 	if (had_failures(req, error)) {
 		fail = 1;
 		goto failed;

--=-KOyP5zrHwHNXVKmS9D+g
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-KOyP5zrHwHNXVKmS9D+g--
