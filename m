From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [dm-devel] Re: [PATCH resubmit] do_mount: reduce stack consumption
Date: Mon, 7 Nov 2005 17:15:22 +0100
Message-ID: <20051107161522.GA28164@osiris.boeblingen.de.ibm.com>
References: <20051104105026.GA12476@osiris.boeblingen.de.ibm.com> <20051104084829.714c5dbb.akpm@osdl.org> <20051104212742.GC9222@osiris.ibm.com> <20051104235500.GE5368@stusta.de> <20051104160851.3a7463ff.akpm@osdl.org> <Pine.GSO.4.60.0511051108070.2449@mango.itee.uq.edu.au> <20051104173721.597bd223.akpm@osdl.org> <17260.17661.523593.420313@cse.unsw.edu.au> <17262.40176.342746.634262@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964842AbVKGQP0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17262.40176.342746.634262@cse.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, aherrman@de.ibm.com, bunk@stusta.de, cplk@itee.uq.edu.au
List-Id: dm-devel.ids

> > Ok, I'll dust it off, make sure it seems to work (at the time I first
> > wrote it, I think it caused 'md' to deadlock) and submit it.
> > 
> > NeilBrown
> > 
> 
> For your consideration and testing (it works for me, but I'd like to
> see it tested a bit more heavily in a variety of configurations).

Works fine for me. Thank you!

However I noticed another recursive call while dumping all call traces:
 ...
 [<00000000001e1952>] zfcp_scsi_command_async+0xf6/0x1c4
 [<000000000013cd6a>] scsi_dispatch_cmd+0x1ae/0x37c
 [<0000000000143dc4>] scsi_request_fn+0x1dc/0x390
 [<000000000012f65a>] generic_unplug_device+0x2a/0x38
 [<0000000000181262>] dm_table_unplug_all+0x42/0x58
 [<000000000017e598>] dm_unplug_all+0x2c/0x44
 [<0000000000181262>] dm_table_unplug_all+0x42/0x58
 [<000000000017e598>] dm_unplug_all+0x2c/0x44
 [<00000000000782aa>] block_sync_page+0x4e/0x68
 [<00000000000514f8>] sync_page+0x48/0x68
 [<00000000002ab36e>] __wait_on_bit+0x9a/0xe0
 ...

Even though there is a lot of space left on the stack (this time) I don't
think it's desirable to have recursive calls. Especially not when going
for 4k stacks.

Heiko
