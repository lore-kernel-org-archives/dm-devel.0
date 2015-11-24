From: Shehbaz Jaffer <shehbazjaffer007@gmail.com>
Subject: Re: Adding new resiliency type to LVM
Date: Tue, 24 Nov 2015 03:05:22 -0500
Message-ID: <CAPLK-i_Bk8QF63wcPFz72Jd7105zY+biP13EvDK_YnACC0HMzA@mail.gmail.com>
References: <CAPLK-i8-Agg+LOjw5w5G9epu1yGyUaGeY1Jv1rGV9Zp3rpXjDw@mail.gmail.com>
	<20151120131704.GC903@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151120131704.GC903@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Thanks. verbose mode exposed more parts of code in device mapper code
that I had to implement in order for my new target type "dyre" to get
identified.

My current problem is when there is an ioctl call, I am getting an
error with errno set to 22, which corresponds to "Invalid argument".

Could you please tell me where can I get the kernel part of the code
which handles the device mapper target? similar to "striped" target, I
think I need to add code there for my "dyre" target.

Thank you again for your help.
Regards,


On Fri, Nov 20, 2015 at 8:17 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Thu, Nov 19, 2015 at 04:25:44PM -0500, Shehbaz Jaffer wrote:
>> ln -s /dev/dm-0 /dev/mapper/vol_vg-root
>
> Lots of pieces of code are involved - if you are using udev, then udev rules
> are responsibly for managing it.
>
> For debugging, check you have 'activation/verify_udev_operations' set to 1 in
> lvm.conf.
>
> Alasdair
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel



-- 
Shehbaz Jaffer
First Year Graduate Student
Sir Edward S Rogers Sr Department of Electrical and Computer Engineering
University of Toronto
