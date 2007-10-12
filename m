From: "Domenico Viggiani" <dviggiani@tiscali.it>
Subject: dup mpath?
Date: Fri, 12 Oct 2007 09:58:04 +0200
Message-ID: <000001c80ca5$9e4ef150$222813ac@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,
what's the exact meaning of these messages:

 # multipath -v2    
 remove: mpath9 (dup of mpath1)
 mpath9: map in use
 remove: mpath13 (dup of mpath2)
 mpath13: map in use

?
If mpath9/13 already exist, why does multipath try to create mpath1/2?

System (RH 4.5) is just rebooted, storage is EMC Clariion CX700.
LVM is in use.

Thanks
--
DV
