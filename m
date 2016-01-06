From: Jeff Moyer <jmoyer@redhat.com>
Subject: can't boot with linux-next-20160104
Date: Wed, 06 Jan 2016 17:34:50 -0500
Message-ID: <x49ziwibalx.fsf@segfault.boston.devel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
Cc: Scotty Bauer <sbauer@eng.utah.edu>
List-Id: dm-devel.ids

Hi,

commit ead3db62bf10f (dm ioctl: do not directly deference user memory in
check_version()) causes my machine not to boot.  I get errors like the
following and then get dumped into a recovery shell:
  device-mapper: version ioctl on  failed: Bad address
  Incompatible libdevmapper (unknown version) and kernel driver (unknown version).

Reverting the above patch fixes the issue for me.

Cheers,
Jeff
