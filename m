From: Mike Tran <mhtran@us.ibm.com>
Subject: [Fwd: Multipath Tools.]
Date: Tue, 27 Sep 2005 17:06:20 -0500
Message-ID: <1127858780.3119.18.camel@miketran.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, dm-devel <dm-devel@redhat.com>, brad@seatab.com
List-Id: dm-devel.ids

Hi Brad,

Since you use Device Mapper, I am forwarding your message to
dm-devel@redhat.com list.  Developers on dm-devel should be able to help
you.

--
Mike Tran

-------- Forwarded Message --------
From: Brad Dameron <brad@seatab.com>
To: linux-raid@vger.kernel.org
Subject: Multipath Tools.
Date: Tue, 27 Sep 2005 14:40:11 -0700

Trying to get multipath round-robin working on a dual-port Qlogic 2300
fiber card with both path's connected to a Sun A5200. I can see the
drives twice from the OS. So I know both path's are fine. I can then
partition the drives. 

I am running on SuSe 9.3 which has this version of multipath tools: 
multipath-tools-0.2.1-3

I did the following to run a quick test:

echo "0 35563590 multipath 2 round-robin 1 0 8:16 round-robin 1 0 8:192"
| dmsetup create dm-0
echo "0 35563590 multipath 2 round-robin 1 0 8:32 round-robin 1 0 8:208"
| dmsetup create dm-1


linux:~ # ls -l /dev/dm-*
lrwxrwxrwx  1 root root 11 Sep 27 01:35 /dev/dm-0 -> mapper/dm-0
lrwxrwxrwx  1 root root 11 Sep 27 01:36 /dev/dm-1 -> mapper/dm-1


linux:~ # ls -l /dev/mapper/
drwxr-xr-x   2 root root    144 Sep 27 01:42 .
drwxr-xr-x  36 root root 182216 Sep 27 01:47 ..
lrwxrwxrwx   1 root root     16 Sep 26 18:42 control -> ../device-mapper
brw-------   1 root root 253, 0 Sep 27 01:35 dm-0
brw-------   1 root root 253, 1 Sep 27 01:36 dm-1



Here is my multipath.conf:
defaults {
        multipath_tool  "/sbin/multipath -v 0 -S"
        udev_dir        /dev
        polling_interval 10
        default_selector        "round-robin 1"
        default_path_grouping_policy    multibus
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    "/bin/false"
        r_min_io        100
}

blacklist {
        devnode "(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "hd[a-z][[0-9]*]"
        devnode "cciss!c[0-9]d[0-9]*[p[0-9]*]"
}

multipaths {
        multipath {
                wwid                    320000004cf278d89
                alias                   multipath1
                path_grouping_policy    multibus
                path_selector           "round-robin 1"
        }
        multipath {
                wwid    320000004cf8f2eda
                alias   multipath2
        }
}

devices {
        device {
                vendor                  "SEAGATE        "
                product                 "ST336605FSUN36G"
                path_grouping_policy    group_by_serial
                path_checker          tur
        }
}


Then I do a "multipath -v 2" and get:

# all paths :
# all multipaths :
# device maps :

Once I get this working my plan is to software RAID10 them together.
Anyone done something like this before?

Any help to get this going appreciated.

Thank you,
Brad Dameron
SeaTab Software


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


