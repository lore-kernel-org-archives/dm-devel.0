From: Christoph Hellwig <hch@lst.de>
Subject: Re: randconfig build error with next-20150908, in
	drivers/md/dm-mpath.c
Date: Wed, 9 Sep 2015 18:04:18 +0200
Message-ID: <20150909160418.GB28608@lst.de>
References: <CA+r1ZhgR=dO0ezk0Nm0JuAb1D0AU7K2Am=Pyy9aPqCMsLW9Y0w@mail.gmail.com> <20150908172356.GA1584@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150908172356.GA1584@redhat.com>
Sender: linux-next-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, agk@redhat.com, dm-devel@redhat.com, James Bottomley <JBottomley@Odin.com>
List-Id: dm-devel.ids

Does this fix the issue for you?  My Kconfig-fu isn't the best,
but the idea behind this is that dm-mpath will depend on SCSI
if SCSI_DH is set.  If SCSI_DH is not set it will use the stubs
and not care about SCSI.

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index b597273..e9ea681 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -393,7 +393,7 @@ config DM_MULTIPATH
 	# of SCSI_DH if the latter isn't defined but if
 	# it is, DM_MULTIPATH must depend on it.  We get a build
 	# error if SCSI_DH=m and DM_MULTIPATH=y
-	depends on SCSI_DH || !SCSI_DH
+	depends on !SCSI_DH || SCSI
 	---help---
 	  Allow volume managers to support multipath hardware.
 
