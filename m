From: Yonathan Cohen <yonic@voltaire.com>
Subject: multipathd failback
Date: Wed, 25 Oct 2006 08:49:38 +0200
Message-ID: <453F0902.6030902@Voltaire.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hello.
My "multipathd" daemon does not FailBack
It does not check the availability of a failed path and of course does 
not reinstate it
My configuration is as follows:
cat /etc/multipath.conf

defaults {

        failback        immediate
}
I am using the following packages:
multipath-tools-0.4.5-0.11
device-mapper-1.01.01-1.6
I have them installed on a SUSE LINUX Enterprise Server 9 (x86_64) sp-3
With kernel version: 2.6.5-7.244-smp
Please help.
Thanks.

____________________________________________________________

Cohen Yonatan   |  +972-9-9718607 (o)  

Software. Eng,  Storage group

Voltaire - _The Grid Backbone_
