Received: from mail.189.cn (189sx01-ptr.21cn.com [125.88.204.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB05A1D8E01
	for <dm-devel@lists.linux.dev>; Sun, 19 Apr 2026 00:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=125.88.204.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776558075; cv=none; b=EgulFwpClsmhipTdZgJ/sVEkbzK8zAT7uBtdmRWUCmkTEvotnVsOGo4KIcLBFIclobUfBNXfIkTqhauDto4NUFh2wE+F49odX8NI8k9t/WQJd3Z20bgloxZ4PYKvlTkSsvc3gp6SGikuvH7S0yX7dOKT9kTAwBDTX4COecqWmkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776558075; c=relaxed/simple;
	bh=n7RvdwwyxgFcYjvNyAgeH/BTooOtpphxA4vkMUajWJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=myOH+z4IeAJ4edgLFcyR0RKAMg3cr38R+zLUBd3smmVsAj2xiUbDvOENbGcxdShv2P0CDzBQFpvcQiKqo7D7EEdtAmVs3rw4Pvz/VP3uNXFYFQFsqpZGU1lP6Xtqi607JXpWZkaOWrXSULG33owbJ0nDP0n1CI6zCVepmG97fVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn; spf=pass smtp.mailfrom=189.cn; arc=none smtp.client-ip=125.88.204.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=189.cn
HMM_SOURCE_IP:10.158.242.145:0.272028814
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-60.27.224.181 (unknown [10.158.242.145])
	by mail.189.cn (HERMES) with SMTP id A4E65400083;
	Sun, 19 Apr 2026 08:21:08 +0800 (CST)
Received: from  ([60.27.224.181])
	by gateway-153622-dep-76cc7bc9cd-r45x9 with ESMTP id 7f3f162eb12d49658ed84c9b5a5c81dd for david.laight.linux@gmail.com;
	Sun, 19 Apr 2026 08:21:11 CST
X-Transaction-ID: 7f3f162eb12d49658ed84c9b5a5c81dd
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 60.27.224.181
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
Message-ID: <5838a534-8ec3-4bb5-bbce-4271fd456cc3@189.cn>
Date: Sun, 19 Apr 2026 08:21:06 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
To: David Laight <david.laight.linux@gmail.com>
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
 sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, paulmck@kernel.org, frederic@kernel.org,
 mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
 samitolvanen@google.com, atomlin@atomlin.com, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mark.rutland@arm.com,
 mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
References: <20260415070137.17860-1-chensong_2000@189.cn>
 <20260416133004.07bd2886@pumpkin>
Content-Language: en-US
From: Song Chen <chensong_2000@189.cn>
In-Reply-To: <20260416133004.07bd2886@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 4/16/26 20:30, David Laight wrote:
> On Wed, 15 Apr 2026 15:01:37 +0800
> chensong_2000@189.cn wrote:
> 
>> From: Song Chen <chensong_2000@189.cn>
>>
>> The current notifier chain implementation uses a single-linked list
>> (struct notifier_block *next), which only supports forward traversal
>> in priority order. This makes it difficult to handle cleanup/teardown
>> scenarios that require notifiers to be called in reverse priority order.
> 
> If it is only cleanup/teardown then the list can be order-reversed
> as part of that process at the same time as the list is deleted.
> 
> 	David
> 
> 
> 

Sorry, i don't follow, the notifiers in the list are deleted when 
calling notifier_chain_unregister, other than that, they are traversed 
forward and backward.

Song

