From: Guy Coates <gmpc@sanger.ac.uk>
Subject: Re: multipath/gfs lockout under heavy write
Date: Tue, 25 Jan 2005 09:38:29 +0000 (GMT)
Message-ID: <Pine.OSF.4.44.0501250905070.3050234-100000@ecs2e.internal.sanger.ac.uk>
References: <1106596648.13534.79.camel@laza.eunet.yu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1106596648.13534.79.camel@laza.eunet.yu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


FWIW,  I'm running LVM on top of device mapper to HSV110s,
and it seems to work.

This is my  multipath.conf


devices {
device {
vendor "COMPAQ  "
product "HSV110 (C)COMPAQ"
path_selector           "round-robin 0"
path_grouping_policy "group_by_serial"
getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
path_checker "readsector 0"
#path_checker "tur"
#features "1 queue_if_no_path"
}
}

You might want to try the "readsector 0" checker rather than the
test-unit-ready one. As others have pointed out, if you are running the
qlogic driver then setting

#define QL_DEBUG_LEVEL_2

in drivers/scsi/qla2xxx/qla_dbg.h

makes the driver print out some more useful scsi information.


Guy

-- 
Dr. Guy Coates,  Informatics System Group
The Wellcome Trust Sanger Institute, Hinxton, Cambridge, CB10 1SA, UK
Tel: +44 (0)1223 834244 ex 7199




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
