From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Issue with setting uid/gid/mode in multipath.conf
Date: Thu, 20 Aug 2009 12:25:06 -0700
Message-ID: <1250796306.746.6.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Benjamin,

I have a small issue with setting the uid/gid/mode with multipath tools.

I have the following in my /etc/mulitpath.conf file
------------------
multipaths {
        multipath {
                wwid 3600a0b800011a1ee00003f834a3f7a65
                alias dev4
                mode    0666
                uid     1001
                gid     1001
        }
}
-------------------

After adding this, I do a "multipath -F" following by "multipath" (or
multipath -F followed by /etc/init.d/multipathd restart), I see the
attributes are set properly on the device.

I reboot the system, the device is created (under /dev/mapper) but
attributes are not set as defined in the multipath.conf file.

Have you seen this issue ? 

I am using RHEL 5.3 ga version (kernel and tools).

I am not booting from a multipath device (IOW, there is no
multipath.conf in initrd).

Thanks,

chandra
