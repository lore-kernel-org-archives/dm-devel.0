From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Latest dm-userspace kernel code
Date: Sat, 30 Sep 2006 11:21:02 +0900
Message-ID: <200609300221.k8U2L7UU001919@r-dd.iij4u.or.jp>
References: <m3hcyr4sit.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3hcyr4sit.fsf@guaranine.beaverton.ibm.com>
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

From: Dan Smith <danms@us.ibm.com>
Subject: [dm-devel] Latest dm-userspace kernel code
Date: Thu, 28 Sep 2006 13:59:06 -0700

> Here is my latest dm-userspace kernel code.  This has a lot of
> cleanups and fixes since the last version.  We have been successfully
> using this version for a while and believe it to be quite stable and
> well-performing.  It is not intended to be in final form, but I think
> it should be close to functionally complete.

Here are some comments:

- I think that you can use kernel threads for map_worker since dmu_map
says that we might reorder I/Os.

- What is the purpose of dmu_request->deps? I guess that it is for
preventing I/O being reordered. if so, again, you don't need to do
that.

- Would be better to move non-transport functions (map_worker,
copy_block, etc) to dm-userspace.c?

- How does the current kernel/user interface support multiple
destination feature?

- Needs some cosmetic fixes (removing needless whitespaces and braces,
etc)
