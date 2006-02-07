From: Thomas Berton <thomas.berton@kreno.be>
Subject: Re: device-mapper: device /dev/hdc too small for target
Date: Tue, 07 Feb 2006 20:06:08 +0100
Message-ID: <43E8EFA0.6050805@kreno.be>
References: <43E8DAD6.3030208@kreno.be> <20060207184106.GB22775@tik.ee.ethz.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060207184106.GB22775@tik.ee.ethz.ch>
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

Arno Wagner wrote:

>If you do a 'cat /proc/mdstat', it needs to list the
>'linear' target, like this:
>
>root ~>cat /proc/mdstat 
>Personalities : [linear] [raid0] [raid1] [raid5] [raid10] 
>...
>
This is my output:

storage:~# cat /proc/mdstat
Personalities : [linear] [multipath]
unused devices: <none>
storage:~#
