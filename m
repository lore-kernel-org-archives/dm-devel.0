From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: multipath-tools: symlinks and block devices in
	/dev/mapper
Date: Thu, 6 Aug 2015 21:32:35 +0000
Message-ID: <bfd03f82311649dfa6b878a5cd2e6116@hioexcmbx08-prd.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,

I've seen a couple of cases on distros that use system (RHEL7 and SLES12) where after the
system boots, if you go to /dev/mapper, you will see the mpath entries are a mix of symlinks
to the respective /dev/dm- device, and others are a block device.

After some investigation, it looks like the symlink is created by udev, and the block device
file gets created with the call to dm_lib_exit(), from the multipath command. Of course, if
one has already created its device file, the other can't.

So I'm wondering why do we have both mechanism to create /dev/mapper/ links and files? It
doesn't really hurt anything, but I think it's strange that it's not consistent.

Thoughts?


Thanks,

Sean Stewart
Linux Software Engineer
Hyperscale Storage Group
NetApp
