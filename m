From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: multipath-tools: symlinks and block devices in
	/dev/mapper
Date: Fri, 7 Aug 2015 14:23:38 +0200
Message-ID: <55C4A34A.4070300@gmail.com>
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
To: Sean Stewart <sean.stewart@netapp.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Sean Stewart wrote:

> I've seen a couple of cases on distros that use system (RHEL7 and SLES12) where after the
> system boots, if you go to /dev/mapper, you will see the mpath entries are a mix of symlinks
> to the respective /dev/dm- device, and others are a block device.

It was reported to SuSE time ago, and it was fixed recently.
I did not see this bug in CentOS_7 1503+updates.
