From: Marian Csontos <mcsontos@redhat.com>
Subject: Re: [dm-devel] kernel BUG at lib/percpu-refcount.c:192
Date: Fri, 9 Jun 2017 14:40:39 +0200
Message-ID: <b15d955d-d25f-afe9-b6eb-af34078115bd@redhat.com>
References: <5fd9ae4c-2cf3-360c-ed50-f2517aafda7a@redhat.com>
 <9dcf0086-6d8a-29db-2a27-6c63af988388@redhat.com>
 <20170608133829.GA32626@redhat.com>
 <20170608170719.6kkk4g2gwzrko7wr@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170608170719.6kkk4g2gwzrko7wr@kernel.org>
Content-Language: en-MW
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-raid@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/08/2017 07:07 PM, Shaohua Li wrote:

> 
> Neil fixed a bug in this side recently, which is pretty similar like the
> reported, I'll push the patch to upstream soon. Could you please try my
> for-next tree, and check if you still have the issue?
> 
> Thanks,
> Shaohua

Kernel with the patch applied runs so far fine. All raid tests passed, 
and the whole test suite is being run now.

Thanks!

-- Martian
