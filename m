From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Hibernate/Resume and dm-cache, dm-writeboost...
Date: Wed, 24 Dec 2014 19:35:49 +0100
Message-ID: <549B0785.3060807@rolffokkens.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Kent Overstreet <kmo@daterainc.com>, Mathijs Kwik <mathijs@bluescreen303.nl>
List-Id: dm-devel.ids

Hi all,

On the linux-bcache mailing list the potential issue was brought up 
about writes to backing or caching device after bringing up devices in 
initramdisk, but prior to an actual resume. The actual issue is that 
there should be no writes between hibernation and resume:

http://www.spinics.net/lists/linux-bcache/msg02692.html

If this is an issue for bcache, I can imagine it also is for other 
caching solutions like dm-cache and dm-writeboost. I'm not an expert on 
this, but from my user perspective it seems somewhat concerning (for 
both bcache and the DM caching solutions) and an expert view on this 
might be needed.

Thanks,

Rolf
