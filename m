From: "Paul Menage" <menage@google.com>
Subject: Re: [Question] power management related with cgroup
	based resource management
Date: Sat, 25 Oct 2008 08:43:53 -0700
Message-ID: <6599ad830810250843u10f65917x3388276211e90316@mail.gmail.com>
References: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com>
	<4901B5C2.9070108@linux.vnet.ibm.com>
	<2891419e0810240524u746b731cjcbd127fa4204bd4d@mail.gmail.com>
	<20081024232503.GA20140@srcf.ucam.org>
	<2891419e0810250105j3e210df0pa3ba9665bd35313a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2891419e0810250105j3e210df0pa3ba9665bd35313a@mail.gmail.com>
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
To: Dong-Jae Kang <baramsori72@gmail.com>
Cc: corsetproject@googlegroups.com, xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, Matthew Garrett <mjg@redhat.com>, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Sat, Oct 25, 2008 at 1:05 AM, Dong-Jae Kang <baramsori72@gmail.com> wrote:
> Thank you for your positive opinion about my question
>
> I also hope cgroup framework has good point related with power management
> I think I need more re-consideration for it. ^^
>
> How do you think about cgroup based management of new HW devices, for
> example, SSD, NVRAM and so on.
> Is there any requirement for it ?
> and is there any required work for it?
> I didn't seriously consider  about that until now.^^ so I don't have cool idea
> but, I think it is worthy to find new domain to be applied by existing
> technology

Control Groups is just a framework for associating state with
(user-created) groups of processes. So if you have a problem to solve
that involves tracking state for different processes, or applying
different behaviour to groups of processes based on that group's
state, then cgroups may well be an appropriate tool.

In the case you mention (management of new devices) that's already
somewhat covered by the existing device isolation subsystem - you can
create a cgroup that has (or doesn't have) access to particular HW
devices.

Paul
