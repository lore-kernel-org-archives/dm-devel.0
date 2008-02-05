From: Igor M Podlesny <for.poige+linux@gmail.com>
Subject: > You may find that you need to update your lvm userspace tools.
Date: Tue, 05 Feb 2008 12:32:11 +0700
Message-ID: <47A7F4DB.3070406@gmail.com>
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>	<20080202235103.20dd9768.akpm@linux-foundation.org>	<47A71040.5000300@gmail.com> <20080204052709.12f4e0d3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754901AbYBEFcc@vger.kernel.org>
In-Reply-To: <20080204052709.12f4e0d3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 2008-02-04 20:27, Andrew Morton wrote:
> On Mon, 04 Feb 2008 20:16:48 +0700 Igor M Podlesny <for.poige+linux@gmail.com> wrote:
[...]
>>    Now I can say that both 2.6.24-mm1 and 2.6.24-git11 do NOT "see" any
>> of mine LVM-2 disks. pvscan, for e.g., finds nothing at all.
> 
> You may find that you need to update your lvm userspace tools.

	You're right; I've updated my initrd with fresh lvm
userspace-counterpart and now the problem has been fixed. Sorry for
groundless alert.

	Thanks!

-- 
End of message. Next message?
