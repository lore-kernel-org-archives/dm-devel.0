From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: /dev/mapper/<dm_name> symlink not being created
Date: Mon, 14 May 2012 15:43:03 +0200
Message-ID: <4FB10BE7.8090602@redhat.com>
References: <CACmkXc5fQCF78UW1_tEruAiuWL_EgODLt87=ZD-d_f2zT-GPeA@mail.gmail.com>
	<CACmkXc5cEhvdBgHzbNW13cFcoj83LjFea=qwZOq5UUq5vpwdAw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACmkXc5cEhvdBgHzbNW13cFcoj83LjFea=qwZOq5UUq5vpwdAw@mail.gmail.com>
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
Cc: Nicholas Nevin <njnevin@gmail.com>
List-Id: dm-devel.ids

Dne 12.5.2012 16:59, Nicholas Nevin napsal(a):
> Anyone have any thoughts on this?
> 
> Thanks, Nick.
> 
> On Mon, Apr 30, 2012 at 8:08 AM, Nicholas Nevin <njnevin@gmail.com> wrote:
> 
>> In nightly testing of our product the tests do a fair bit of
>> creating/destroying of device mapper devices and we have been seeing
>> infrequent cases where the device is created OK but the corresponding
>> /dev/mapper/<dm_name> symlink does not exist.
>>
>> Here is an example of the dmsetup command used to create the devices.
>>
>> # dmsetup create tap0 --table '0 47247164 linear /dev/xen/blktap-2/tapdev0
>> 1'
>>
>> I managed to reproduce this problem with udev logging enabled and 'udevadm
>> monitor' running and from the logs the cause appears to be that the udev
>> add action (from the device create) and the udev change action (from when
>> the device is resumed after loading the table) are running
>> concurrently. The processing of the rules for the change action creates the
>> /dev/mapper/tap0 symlink but then the processing of the add action deletes
>> the symlink because /dev/mapper/tap0 is not in the add action DEVLINKS.
>>
>> The question I have is should dmsetup be ensuring that the add action
>> completes before the change action is handled or is this behaviour expected?
>>
>> That /dev/mapper/tap0 is not in the DEVLINKS for the add action is AFAICT
>> because of a race between the creation of the sysfs entries for the device
>> and the processing of the add action in udevd. This can be fixed by
>> sprinkling in some WAIT_FOR conditions in the dm udev rules. Our system is
>> based on Ubuntu 12.04.
>>
>> I have attached the udevadm monitor output and the relevant piece of
>> syslog for a test case where the /dev/mapper/tap0 symlink wasn't present
>> when dmsetup returned.
>>
>> I hope this is the right place to ask this. If not please point me in the
>> right direction.

You have not specified version of lvm2 tools in use.

But on udev system there are 2 options when nodes/links are created.

By default it's on RESUME - since this is the moment table is defined,
and proper messages are passed across udev system.

For backward compatibility (and for non-udev systems) there is
dmsetup create --addnodeoncreate  - which basically creates links on 'create'
phase - but with old 'badness' behind - since normally no one should create
nodes in /dev  - it's the  udev 'kingdom' which should not be externally
modified (udev might not know about such entries).

So the proper moment to work with created devices is after they have been
resumed - everything else will be ugly udev hack with unpredictable results.

Zdenek
