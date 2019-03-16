From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: Build: properly parse
 systemd's version
Date: Sat, 16 Mar 2019 23:48:05 +0100
Message-ID: <750069a3-b9dd-0353-1053-60801f875ba3@gmail.com>
References: <20190307145448.2470-1-mwilck@suse.com>
	<8a4f3790-a2a9-27ad-b839-d2b743e939a7@gmail.com>
	<a272001f313ba99e5b2a8d2215acc87c9390e8b4.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a272001f313ba99e5b2a8d2215acc87c9390e8b4.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Igor Gnatenko <ignatenkobrain@fedoraproject.org>, Dominique Leuenberger <dimstar@opensuse.org>, Benjamin Marzinski <bmarzins@redhat.com>, mwilck+gmail@suse.de
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 3/7/19 8:20 PM, Martin Wilck wrote:

> On Thu, 2019-03-07 at 19:22 +0100, Xose Vazquez Perez wrote:
>> On 3/7/19 3:54 PM, Martin Wilck wrote:
>>> From: Dominique Leuenberger <dimstar@opensuse.org>
>>>
>>> Since systemd 241, systemctl --version no longer 'just' prints out
>>> the
>>> version, but gives more information like git commit ref and
>>> whatnot. In
>>> it's shortest form, it gives something like "systemd 241 (241)",
>>> which when
>>> passed as parameter "-DUSE_SYSTEMD=241 (241)" results in shell
>>> errors.
>>>
>>> Try to retrieve the version from pkg-config instead, and if that
>>> fails,
>>> discard anything after the first number in "systemctl --version"
>>> output.
>>
>> There is a simpler patch in Fedora, see below.
> 
> Which is equivalent to the "else" clause of my patch, thanks for
> pointing it out.
> 
> But pkg-config should be the way to go in the future, so why not
> use it if we can?

I agree.
