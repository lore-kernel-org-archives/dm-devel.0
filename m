From: Anselm Busse <abusse@cs.tu-berlin.de>
Subject: Re: [PATCH v3 2/3] init: boot to device-mapper targets
	without an initr*
Date: Thu, 27 May 2010 09:38:17 +0200
Message-ID: <E14718F3-E489-4921-8A5D-FAFCF2C8F8FA@cs.tu-berlin.de>
References: <1274294304-30606-1-git-send-email-wad@chromium.org>
	<1274294304-30606-2-git-send-email-wad@chromium.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1274294304-30606-2-git-send-email-wad@chromium.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

> An example dm-linear root with no uuid may look like:
> 
> root=/dev/dm-0  dm="lroot none 0, 0 4096 linear /dev/ubdb 0, 4096 4096 linear /dv/ubdc 0"
> 
> Once udev is started, /dev/dm-0 will become /dev/mapper/lroot.

Hi,

I'm having the problem that the device - for example - won't come available at "/dev/mapper/lroot" but at "/dev/mapper/lroot ". There is an additional space at the end of the name, which is...lets say not so good. The problem is exists already in the dm_setup_args.name field, so I think is a problem parsing the arguments.

I'm new around here, so I don't know how things work. Should I look into the problem myself and post a fix, or will the author of the patch?

Anselm
