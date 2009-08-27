From: Ric Wheeler <rwheeler@redhat.com>
Subject: Fwd: MD/DM and barriers (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Thu, 27 Aug 2009 13:13:18 -0400
Message-ID: <4A96BEAE.5000504@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

fyi - end of a very long thread, but I thought that dm had this fixed...

ric


-------- Original Message --------
Subject: 	MD/DM and barriers (was Re: [patch] ext2/3: document 
conditions when reliable operation is possible)
Date: 	Thu, 27 Aug 2009 12:54:05 -0400
From: 	Jeff Garzik <jeff@garzik.org>
To: 	Ric Wheeler <rwheeler@redhat.com>
CC: 	Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>, Pavel 
Machek <pavel@ucw.cz>, Florian Weimer <fweimer@bfk.de>, Goswin von 
Brederlow <goswin-v-b@web.de>, kernel list 
<linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, 
mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org, 
linux-ext4@vger.kernel.org, corbet@lwn.net



On 08/27/2009 09:10 AM, Ric Wheeler wrote:
>  One thing that does need fixing for some MD configurations is to stress
>  again that we need to make sure that barrier operations are properly
>  supported or users will need to disable the write cache on devices with
>  volatile write caches.

Agreed; chime in on Christoph's linux-vfs thread if people have input.

I quickly glanced at MD and DM.  Currently, upstream, we see a lot of

         if (unlikely(bio_barrier(bio))) {
                 bio_endio(bio, -EOPNOTSUPP);
                 return 0;
         }

in DM and MD make_request functions.

Only md/raid1 supports barriers at present, it seems.  None of the other
MD drivers support barriers.

DM has some barrier code...  but the above code was pasted from DM's
make_request function, so I am guessing that DM's barrier stuff is
incomplete and disabled at present.

I've been mentioning this issue for years... glad some people finally
noticed :)

	Jeff



