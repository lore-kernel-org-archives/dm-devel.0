From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: Re: dm-thin btree and incremental backup issue
Date: Wed, 3 Jul 2013 01:18:14 +0800
Message-ID: <CAKTMprN8ctu4p7x55n1WTBEEnc4W0G_ux4Dwq7fUtFXr5CQ+0A@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

> On Tue, Jul 02, 2013 at 10:41:31AM +0800, Teng-Feng Yang wrote:
>> Hi folks,
>>
>> I am currently implementing an incremental backup tool of
>> dm-thin-provisioning volumes based on this post
>
> Well done!  I've been meaning to do this for ages.  Is your code
> published so I can help out?
>

Good to know :)
This project is not yet published, since it is still not very stable
at this point of time.
I think it may still require lots of effort on testing and
verification to make sure it is ready for production use.

>> (https://www.redhat.com/archives/dm-devel/2012-May/msg00140.html).
>> I clone the latest thin-provisioning-tools from github and use ubuntu
>> 13.04 (linux 3.8.0-19) as host OS. However, as I try to perform some
>> stress tests on my backup tool, I find a weird output of thin_dump
>> which I cannot be sure if it is a bug or not.
>
> Yep, it's a bug, and was fixed on Friday.
>
> https://github.com/jthornber/thin-provisioning-tools/commit/e701b966427111f50fee21ae3d9eb5703268152c
> https://github.com/jthornber/thin-provisioning-tools/commit/fe8e1592a98abc580750aaa4ad5c20a496646d4f
>

I pulled the latest commit from github today, and I still confirmed
the same behavior as described in my previous mail. Therefore, I spent
some time trying to fix this issue, and I think I might find where the
problem is. When a device has only a few data mappings, it seems that
the subroot node of this devices' bottom-level btree will be a LEAF
node instead of an INTERNAL node. Since metadata_dump only checks if
current key matches to target dev_id when it visits an INTERNAL node,
the data mappings of other devices with only a few data mappings still
appends to all the devices' data mapping dump. Therefore, I apply the
same dev_id checking when metadata_dumper visits LEAF node as well,
and it works. However, I am not quite sure if this fix is correct and
has no "side effects" to mess things up.

>
> However I suggest you stick to the tagged 0.1.4 release (there is a
> new release due in the next couple of days).
>
> - Joe

Thanks for your help
Dennis
