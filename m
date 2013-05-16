From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: A question about dm-raid1 on CentOS5.8
Date: Thu, 16 May 2013 16:22:25 -0500
Message-ID: <7EEBF643-98D5-4051-A028-F1BF87CDFB3D@redhat.com>
References: <tencent_33741930094DEBBE0A3858F5@qq.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <tencent_33741930094DEBBE0A3858F5@qq.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


On May 14, 2013, at 2:36 AM, Striver/sj wrote:

>   Hi guys
> I create a mirror device on CentOS5.8, the table is 
> "0 8372224 mirror core 3 4096 nosync block_on_error 2 8:16 8192 8:32 8192"
> But I found when I offline the first leg of the mirror device. All write IO is hung up.
> But it will not occur on CentOS5.3/5.4, in my opinion, if one leg returns IO error, 
> IO will continue if there is still other good leg.
> So does this should be deal with by user space (dmeventd)? Or I make something error. 
> 

Yes, it should be handled by dmeventd.  (dmeventd will notice the event raised by the kernel and attempt a 'lvconvert --repair vg/lv' or 'vgreduce --removemissing vg if old enough.)

You should find that a 2-way mirror is converted to a linear device when one of the legs fails.

 brassow
