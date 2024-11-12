Received: from osmtp.synthetel.com (osmtp.synthetel.com [149.56.45.145])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B13420B218
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 19:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.56.45.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731440429; cv=none; b=WmWMN7oWjIHIuFiy/SC0w2WA8mRvIeeuDTWTYznCVwfu9CSXVdRjCxN7ZB2W5Cak+Wzpw3DbWhvZikaZlSgJnehba8PKe+QEkGvzeCpbf7+BsXoc6my6KA7nYstBVnOiHG3fvDoeyaMcgX8xUxhAJYePXj5fN7Jv9onTAHG0+5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731440429; c=relaxed/simple;
	bh=jkWW1/lhwQLfOn5yHGdwXWP+iu325JKjA1yVW6kwAqs=;
	h=MIME-Version:Content-Type:Date:From:To:Subject:Message-ID; b=jXQRczOr3Dbaq209n49rDh6tvbkbnFSH54C+lWX9YlFHLhNruMaY5K23Jsyw7fri57WMO3riyf3cBBjsrAbGexGoBhBXOIMvEc8IIZL1WjveBE8a9xhW+z7iVYaZ9Xa2nM/ErOZM0/+WXS+R1YivA9ZzgbdwviED2/d11oKxG6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=synthetel.com; spf=pass smtp.mailfrom=synthetel.com; dkim=pass (1024-bit key) header.d=synthetel.com header.i=@synthetel.com header.b=rY94BWZr; arc=none smtp.client-ip=149.56.45.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=synthetel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synthetel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synthetel.com header.i=@synthetel.com header.b="rY94BWZr"
Received: from sha0.net (unknown [10.0.0.13])
	by osmtp.synthetel.com (Postfix) with ESMTPSA id F32C0C0DAD
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 19:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synthetel.com;
	s=default; t=1731440423;
	bh=jkWW1/lhwQLfOn5yHGdwXWP+iu325JKjA1yVW6kwAqs=;
	h=Date:From:To:Subject;
	b=rY94BWZrnxfD7GqY2w3cJZABpNWJTUAzLEZnJwVfKPoFnnJfZ6ozDpAQYy7yrs2Cj
	 lkEWO5GPx856xfn0VMTa8iZ87QVv6osJi91e/B3DFmhVdjSxhm3RC2g3AvbtMfw81h
	 8kPr/KHuai6PQ/XlpcO2UvBcjiCPGGVypeMZ6R7U=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Nov 2024 11:40:23 -0800
From: Shao Miller <device.mapper@synthetel.com>
To: dm-devel@lists.linux.dev
Subject: Copy on Read
Organization: Synthetel Corporation
Message-ID: <db1f26b55bd68277b0944179dd11b298@synthetel.com>
X-Sender: device.mapper@synthetel.com
User-Agent: Roundcube Webmail/1.0.12

Good day, Device Mapper Folks.

In the format of an X Y Problem:

[Almost] Real goal (X): I would like to read storage-blocks locally from 
a far-away (remote, high latency) source and keep costs (for local 
storage, for network-traffic) to a minimum.  95% of the remote source 
will never be read and 5% will be read frequently.  If I read a 
storage-block 1,000,000 times over 10 years, ideally it should only 
traverse the network once during that time.

There is no mention of writes, so far.

Sub-goal (Y): Identify whether or not there is a device-mapper target 
with copy-on-read, read-only behaviour.  This seems like it could be 
useful in certain forensic situations in which "accesses" ought to be 
recorded.  "We" (device-mapper users) have the "write half" of 
"accesses" covered, already, with snapshots.

dm-cache might work out, except that it appears to've been designed with 
considerations for writes, which are irrelevant to the goal(s).

dm-snapshot might work out, except that I'd like to copy-on-read, 
instead of copy-on-write.

dm-thin appears to pass reads to the source, so doesn't seem to be 
appropriate.

dm-clone doesn't keep costs low because it copies the 95% unused 
storage-blocks.  dm-clone without any writes happening and with 
"hydration" disabled might work out, except that it appears to pass 
reads to the source, with "hydration" disabled.

Mirroring doesn't keep costs low because it copies the 95% unused 
storage-blocks.

Please forgive my ignorance/forgetfulness: is there already a 
device-mapper target or a stack of targets which seem(s) appropriate for 
the goal(s)?  The idea is pretty much read-caching, which might be 
argued is also available at filesystem layers, but files aren't 
mentioned in the goal(s).

Thank you for your generous device-mapper efforts.

- Shao Miller
Synthetel Corporation
