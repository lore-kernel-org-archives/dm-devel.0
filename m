From: malahal@us.ibm.com
Subject: [RFC] friendly names and multipath tools
Date: Tue, 26 Jun 2007 18:40:38 -0700
Message-ID: <20070627014038.GA20533@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Hi All,
	
	I noticed the following behaviour with friendly names in the
multipath configuration files:

/dev/disk/by-id/scsi-mpath0 symlink is created pointing to actual dm
device node (i.e. /dev/dm-0), also /dev/disk/by-name/mpath0 symlink
pointing to the same dm device node. It doesn't look right to create
name/alias based entry in the /dev/disk/by-id/ space. In other words,
the actual by-id symlink is NOT created at all! How about creating the
actual by-id name in the /dev/disk/by-id/ directory and alias name in
/dev/disk/by-name/ directory?

If an admin specifies a real by-id name as boot device for booting, he
couldn't boot with 'friendly names' ON today. The above solution would
fix that.

Thanks, Malahal.
