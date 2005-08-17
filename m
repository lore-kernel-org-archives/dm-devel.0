From: Alan Kasindorf <akasindorf@mail.communityconnect.com>
Subject: Re: multipath-tools-0.4.4 on 3par unknown path failure
	issue
Date: Wed, 17 Aug 2005 15:38:38 -0400
Message-ID: <4303923E.1000606@mail.communityconnect.com>
References: <42FA7674.4070201@mail.communityconnect.com>	<20050811195540.GA16665@thumper2>
	<42FBB2CC.2040508@mail.communityconnect.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42FBB2CC.2040508@mail.communityconnect.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

I could use some suggestions on how to approach the issue at this 
point... We're in a bad position because this bug did not come out 
during a single instance test.

I have tried adjusting QLogic timeouts and any related parameters to see 
if a higher or lower timeout would affect the issue at all, and it's 
done nothing but make the problem worse.

I'm confident in what folks have said about 2.6.12 and later not 
exhibiting this issue. However, I have a redhat kernel running Oracle, 
and we need them to not drop our support. Currently redhat's support is 
ignoring me as well. Should I talk with the QLogic maintainer at all? 
3par has no clue, unless they're hiding their "Linux guy" from me.

Does SuSE professional have this patched up? We might be able to switch 
to their distro if they will actually support multipathing on a database 
in their mainline kernel, vs not at all.

Thanks,
-Alan

> We're running 2.6.9-11.ELsmp, off of redhat ES 4.1. I don't exactly have 
> the entire list of redhat patches on hand, so I can't say for sure. Nor 
> can I actually modify our kernel without losing support to the box. If 
> this is fixed with a kernel upgrade, we can open a support ticket from 
> redhat and scream/yell until they apply the patch.
