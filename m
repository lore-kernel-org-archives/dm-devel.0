From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 2/2] multipath-tools: add GPLv2 as COPYING
Date: Wed, 28 Mar 2018 21:31:54 +0200
Message-ID: <0e96c823-6a67-a07d-ea09-09a55f66c8c3@gmail.com>
References: <20180327182819.20163-1-xose.vazquez@gmail.com>
	<20180327182819.20163-2-xose.vazquez@gmail.com>
	<1522188292.13140.54.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1522188292.13140.54.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 03/28/2018 12:04 AM, Martin Wilck wrote:

> On Tue, 2018-03-27 at 20:28 +0200, Xose Vazquez Perez wrote:
>> Source directly from: https://www.gnu.org/licenses/old-licenses/gpl-2
>> .0.txt
>>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> 
> Do you plan to add a README.COPYING or similar explaining which license
> applies to what part of the code?


No, I do not. It should be done by the current maintainer and/or files
copyright owners.


Currently the best and standard way is to use "SPDX License Identifier",
since many of the Linux Foundation projects are starting to employ it:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/license-rules.rst#n35
