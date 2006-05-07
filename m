From: Erez Zilber <erezz@voltaire.com>
Subject: Re: Setting up a multipath device
Date: Sun, 07 May 2006 17:01:01 +0300
Message-ID: <445DFD9D.4040402@voltaire.com>
References: <445A0AE9.20907@voltaire.com>
	<20060504144915.GA2319@pundit>	<445A1D88.7030500@voltaire.com>
	<1146768927.27764.12.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1146768927.27764.12.camel@localhost.localdomain>
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

Some more questions:

   1. I couldn't find the config file. Where is it located? Is there any
      documentation about it?
   2. How can I configure fancy naming for devices (instaed of using
      something like /dev/mapper/3600c0ff00000000007c1d121c397f503) in
      the config file?
   3. How can I config the delay from the time that a device has failed
      until the dm moves to the next active device? Again, I understand
      that I should use the config file somehow.

I tried to run the following test: I created a multipath device with 2 
physical devices (/dev/sda & /dev/sdb). I started running traffic on the 
multipath device. All traffic ran through /dev/sda. Then, I disconnected 
the iSCSI target that was represented by /dev/sda. After some time, the 
traffic was directed to /dev/sdb. I stopped the traffic, disconnected 
the iSCSI target that was represented by /dev/sdb and reconnected 
/dev/sda. Now, if I run `multipath -l`, I see the following output:

3600c0ff00000000007c1d121c397f503
[size=10 GB][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][enabled]
 \_ 0:0:0:0 sda 8:0   [failed][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:0 sdb 8:16  [failed][faulty]

/dev/sdb is dead and I'm ok with it. However, /dev/sda is alive. I was 
able to run the following command:

dd if=/dev/sda of=/dev/null count=100000

However, if I run the following command:

dd if=/dev/mapper/3600c0ff00000000007c1d121c397f503 of=/dev/null 
count=100000

This is what I get:

dd: reading `/dev/mapper/3600c0ff00000000007c1d121c397f503': 
Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00067 seconds, 0.0 kB/s

Can't it recongnize that a device that has failed (/dev/sda) is back to 
life?

Thanks
Erez
