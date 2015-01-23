From: Dennis Yang <shinrairis@gmail.com>
Subject: A couple of questions related to dm-thin in
	linux-3.19-rc5
Date: Fri, 23 Jan 2015 12:58:52 +0800
Message-ID: <CAKTMprNkA3ox_GiqAU9r6DY0b-5MJ4nz=ggCoGu1jGP5oWNNvg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hi,

I have noticed that there are a bunch of outstanding performance
patches applied to dm-thin in linux-3.19 including deferring the whole
cell instead of only a single bio. Based on the source of
linux-3.19-rc5, thin_bio_map() will defer all the DISCARD, FUA, and
FLUSH bios by default and try to defer the cell by calling
thin_defer_cell() for normal read/write bio requests. As what I have
learned from the source, thin_bio_map() is the only one which calls
thin_defer_cell() to defer only the cells with a normal read/write bio
as its holder. However, process_thin_deferred_cell() still tries to
deal with the case that a deferred cell might have a DISCARD bio as
its holder which I don't understand how this could happen. Please do
correct me if I misunderstand anything.

The second question is related to dm_table_event. When dm-thin's free
space reaches its low water mark, it will call dm_table_event which
eventually send all uevents pending at pool mapped device's uevent
list. As far as I know dm-thin does not define and add any uevent into
this list, I am not sure why we should still call dm_table_event at
this point. Another question is, if this function does not send out
any uevent for user space to know that free space is running low, is
there any formal way to let user space get this message? Or should I
just create a new sysfs attribute to export it?

Any help would be grateful.
Thanks for your patience.

Dennis
