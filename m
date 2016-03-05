From: Steven Wilton <swilton@fluentit.com.au>
Subject: Re: [PATCH 2/2] - writeback delay
Date: Sat, 5 Mar 2016 23:29:31 +0800
Message-ID: <56DAFB5B.4090307@fluentit.com.au>
References: <56D84963.7000301@fluentit.com.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010604090708000905050000"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56D84963.7000301@fluentit.com.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010604090708000905050000
Content-Type: multipart/alternative;
	boundary="------------020502020605090408050102"


--------------020502020605090408050102
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

I just realised that I had also made a change to dm-cache-target.c 
(attached) to make sure the policy set_dirty function is called every 
time we write to a cache block to ensure that the writeback time us 
updated for a hot block.

Steve

On 03/03/16 22:25, Steven Wilton wrote:
> Hi,
>
> Please find attached a patch for the dm-cache mq policy that adds 
> another config option of writeback_delay which adds a fixed delay for 
> any write hits before a writeback will be performed.  I have tested 
> the patch on a development system, and confirmed that the writeback 
> occurs after the configured time, and does not appear to cause any 
> issues.  I also confirmed that overwriting the same block delays the 
> writeback indefinitely, while also avoiding the copy operation from 
> SSD to HDD (which is my reason for creating the patch).
>
> I am interested to get confirmation that this patch does not have any 
> glaring errors, and getting it merged if it is considered useful.  The 
> DEFAULT_WRITEBACK_DELAY option can be set to 0 if you want to merge 
> the code without affecting the behaviour of existing deployments.
>
> The patch is available as a git commit here:
> https://github.com/eskyuu/linux/commit/565a6e57fa5a55bdd6656ae89a28543a9d871f52 
>
>
>
> The dm-cache policy could be improved further to defer writebacks 
> until the cache is getting full (high/low watermarks), or trying to 
> keep sequential dirty blocks together so we write them back 
> sequentially.  I am happy to develop and test along these lines if 
> needed.
>
>
> I can confirm that this patch does make removing the cache more 
> difficult, since the cache removal code waits for all writeback to 
> complete before removing the cache.  I had a look at the lvm2 code, 
> and I'm not sure if the cleaner policy is meant to be applied before 
> waiting for the writebacks to complete.  At the worst case, the 
> user-space program could be modified to set the writeback delay to 0, 
> which would mirror the existing behaviour.
>
> regards
>
> Steven
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------020502020605090408050102
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx5-phx2.redhat.com id u25FdY4M041179

<html>
  <head>
    <meta content=3D"text/html; charset=3Dwindows-1252"
      http-equiv=3D"Content-Type">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    I just realised that I had also made a change to dm-cache-target.c
    (attached) to make sure the policy set_dirty function is called
    every time we write to a cache block to ensure that the writeback
    time us updated for a hot block.<br>
    <br>
    Steve<br>
    <br>
    <div class=3D"moz-cite-prefix">On 03/03/16 22:25, Steven Wilton wrote=
:<br>
    </div>
    <blockquote cite=3D"mid:56D84963.7000301@fluentit.com.au" type=3D"cit=
e">Hi,
      <br>
      <br>
      Please find attached a patch for the dm-cache mq policy that adds
      another config option of writeback_delay which adds a fixed delay
      for any write hits before a writeback will be performed.=A0 I have
      tested the patch on a development system, and confirmed that the
      writeback occurs after the configured time, and does not appear to
      cause any issues.=A0 I also confirmed that overwriting the same
      block delays the writeback indefinitely, while also avoiding the
      copy operation from SSD to HDD (which is my reason for creating
      the patch).
      <br>
      <br>
      I am interested to get confirmation that this patch does not have
      any glaring errors, and getting it merged if it is considered
      useful.=A0 The DEFAULT_WRITEBACK_DELAY option can be set to 0 if yo=
u
      want to merge the code without affecting the behaviour of existing
      deployments.
      <br>
      <br>
      The patch is available as a git commit here:
      <br>
<a class=3D"moz-txt-link-freetext" href=3D"https://github.com/eskyuu/linu=
x/commit/565a6e57fa5a55bdd6656ae89a28543a9d871f52">https://github.com/esk=
yuu/linux/commit/565a6e57fa5a55bdd6656ae89a28543a9d871f52</a>
      <br>
      <br>
      <br>
      The dm-cache policy could be improved further to defer writebacks
      until the cache is getting full (high/low watermarks), or trying
      to keep sequential dirty blocks together so we write them back
      sequentially.=A0 I am happy to develop and test along these lines i=
f
      needed.
      <br>
      <br>
      <br>
      I can confirm that this patch does make removing the cache more
      difficult, since the cache removal code waits for all writeback to
      complete before removing the cache.=A0 I had a look at the lvm2
      code, and I'm not sure if the cleaner policy is meant to be
      applied before waiting for the writebacks to complete.=A0 At the
      worst case, the user-space program could be modified to set the
      writeback delay to 0, which would mirror the existing behaviour.
      <br>
      <br>
      regards
      <br>
      <br>
      Steven
      <br>
      <br>
      <fieldset class=3D"mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap=3D"">--
dm-devel mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:dm-devel@redhat.com"=
>dm-devel@redhat.com</a>
<a class=3D"moz-txt-link-freetext" href=3D"https://www.redhat.com/mailman=
/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><=
/pre>
    </blockquote>
    <br>
  </body>
</html>

--------------020502020605090408050102--

--------------010604090708000905050000
Content-Type: text/x-patch;
 name="dm-cache-target.patch"
Content-Disposition: attachment;
 filename="dm-cache-target.patch"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 7755af3..7dab682 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -532,8 +532,8 @@ static void set_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cbloc
 {
 	if (!test_and_set_bit(from_cblock(cblock), cache->dirty_bitset)) {
 		atomic_inc(&cache->nr_dirty);
-		policy_set_dirty(cache->policy, oblock);
 	}
+	policy_set_dirty(cache->policy, oblock);
 }
 
 static void clear_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)

--------------010604090708000905050000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--------------010604090708000905050000--
