From: "Sunil Joshi" <mail2joshi@gmail.com>
Subject: how to do failover using device mapper
Date: Fri, 23 Feb 2007 16:37:54 +0530
Message-ID: <778391c50702230307m11bf9d67s24e1bc554c926ba4@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi Experts,
I am trying to find a way to path failover  using device mapper.
I have configured /etc/multipath.conf and other instructions as given
in http://kbase.redhat.com/faq/FAQ_51_7170.shtm.

I can see multipath -ll output which shows two entries corresponding
to two path connected to system.
e.g
\_ round-robin 0 [enabled]
 \_ 4:0:0:0 sdc 8:32  [active][ready]
 \_ 3:0:0:0 sdg 8:96  [active][ready]


ls -l /dev/dm-* shows
brw-r-----  1 root root 253, 0 Feb 23 03:11 /dev/dm-0
brw-r-----  1 root root 253, 1 Feb 23 03:11 /dev/dm-1


I have 7 partitions on /dev/sdc and want to mount a particular device
/dev/sdc7.  How should I do it. I want to mount the sdc7 , then in
between of I/O activity I will close the port so that I/O will direct
to other port.

I dont want to use mdadm  , so any other way to create group of device ?

I have many more questions , like
1) What /dev/dm-# indicates.
2) What kpartx does

I searched the mail archive but not able to find suitable.

Thanks for your time.

Regards
sjoshi
