From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: PATCH 0/4] multipath-tools: Ceph rbd support v2
Date: Wed, 10 Aug 2016 08:42:04 -0700
Message-ID: <daa224ee-612e-1ab4-af1e-9b13cc64db36@sandisk.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
	<CABr-Gnf1vfGOMGcP8YF2tFMy5Z2Buwp7H9iXfCzuDC-S+FE7AA@mail.gmail.com>
	<57AA2060.20708@redhat.com>
	<CABr-GndTq8hUNw8w_ES773R2LqpitkZm+=8JTfhJVktwuuSwfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GndTq8hUNw8w_ES773R2LqpitkZm+=8JTfhJVktwuuSwfg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Mike Christie <mchristi@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/10/2016 12:55 AM, Christophe Varoqui wrote:
> Distributors will surely want to build all checkers to have the docs and
> hwtable in sync with the shipped checkers, and cover the widest range of
> setups.
>
> I'd rather drop this patch or, if it proves to be a problem, merge a
> variant with the rbd checker build by default and not-buildable by
> explicit define.

Hello Mike and Christophe,

How about detecting at compile time whether the rbd header files are 
available? That approach avoids that we have to introduce a configure 
script and also avoids that the user has to enable rbd support 
explicitly. In e.g. the fio makefile there are several tests to check 
which libraries are available and can be used during the fio build.

Bart.
