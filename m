From: Bart Coninckx <bart.coninckx@telenet.be>
Subject: understanding of multipathing and speed
Date: Mon, 5 Jul 2010 20:37:39 +0200
Message-ID: <201007052037.39362.bart.coninckx@telenet.be>
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
List-Id: dm-devel.ids

Hi,

I would like to run my ideas by this list about multipathing and the results 
as far as storage speed is concerned.

I'm using multipathing to two iSCSI targets pointing to the same storage. It 
was my understanding that this provides for network path redundancy (and it 
does, I tested this) but also for added speed. 
I did some tests with Bonnie++ however while both paths were active and one 
path was down and the results are basically the same. 

Am I assuming wrong things? Or have I configured things wrong?

This is my config for now:

defaults {
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        path_grouping_policy    multibus
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio                    const
        path_checker            directio
        rr_min_io               100
        max_fds                 8192
        rr_weight               priorities
        failback                immediate
        no_path_retry           5
        user_friendly_names     no
}
blacklist {
       wwid 26353900f02796769
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z][[0-9]*]"
        devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
        device {
                vendor DEC.*
                product MSA[15]00
        }
}
multipaths {
 multipath {
                wwid                    
1494554000000000000000000010000000000000002000000
  alias                   lx03
  }
 multipath {
                wwid                    
1494554000000000000000000010000000100000002000000
  alias                   ws033
  }
 multipath {
                wwid                    
1494554000000000000000000010000000200000002000000
  alias                   ms01
  }
}


Thank you!!

B.
