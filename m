From: Christian Hesse <list@eworm.de>
Subject: Re: dm-crypt TRIM support
Date: Wed, 13 Jul 2011 13:30:58 +0200
Message-ID: <20110713133058.523ef3a5@io.vpn.lugor.de>
References: <4E0A3EF2.4090608@deserettechnology.com>
	<4E0A4545.6070401@redhat.com>
	<4E1C88A2.4020500@deserettechnology.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E1C88A2.4020500@deserettechnology.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jeff@deserettechnology.com, device-mapper development <dm-devel@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Jeff Cook <jeff@deserettechnology.com> on Tue, 12 Jul 2011 11:47:14
-0600:
> Thank you for the update. I would really like TRIM support on my
> dm-crypt SSD and I'm not worried about the revelations that may be
> discernible regarding trimmed space, etc.

I second that. I think TRIM on dm-crypt brings enough security for most
people (including me). It's a lot worse to not use dm-crypt to get TRIM
support. And trashing your SSD is not a good choice either.

Would it have to be configurable? If anybody does not want TRIM it
would still be possible to disable it by mounting filesystems with '-o
nodiscard'.
-- 
Schoene Gruesse
Chris
