Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.130.44.230
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280044;
	b=qH+W7VlQFAHY8HClwIOvZOlueuL3b+Y1aQiLsfgCbJn/Nk9HY47oWY8QuTbIcO45hHmP
	 WNH++tNFnAHnMuuWChxO7d4TzOBfrQ/Irg3a9TznwBOv8rv/8poPDh/S9i1vj4SdLwCEd
	 QaNw3xJtur2EXw7ASOPaahTseqenCtRb2b1EvU2kge0dksXTSW3fXHphaCY4SDHwSUsiY
	 24O5mVhX9S4TWCdWkMYF4vMS22HfOCuF06D+oBROtI9MB8ph0MoxkYd5irpHRyR7ATDF4
	 T57TulYuL6+vIFHjOaWvaYH0kW8lixdAEQ7oK7m5tsTJlUIrkBBcZSfogev3117gD3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280044;
	h=DMARC-Filter:Received:Received:From:To:Subject:Date:Message-ID:
	 Reply-To:Content-Type:Content-Transfer-Encoding:MIME-Version:
	 X-Authenticated-User:X-Authenticator:X-Originating-IP:
	 X-SpamExperts-Domain:X-SpamExperts-Username:
	 X-SpamExperts-Outgoing-Class:X-SpamExperts-Outgoing-Evidence:
	 X-Recommended-Action:X-Filter-ID:X-Report-Abuse-To:X-Complaints-To;
	bh=pWpBIbE1tpakQFXOiqC33gk1ji50hFVwpLCEgZ+UptI=;
	b=wgd5d//d9xpIU/y2AnFcL015XNj+Z3Gs3BndgVCO+8UBDB1EDdVrQQVKlMuIdisBAPUQ
	 9PG0I9MCT2fOSNUKvSi62B34PsunXISTeFuJ6fRsdnGZ2P0/+pazC8J3BPcKgqzeX5d+7
	 TNc7cJFi4XqIa4cUIXnzbyShjJ71p8ttRemb+myyDt9g9Jl0kxomJfh7AdZXp3987Zpdr
	 HRDDhsC/gV299GCZHQil/3uvIXF95Pf6n7jxpURLFWJRuyE2c9s/0DOfIddL1ofU1ICSi
	 2dChrMrJ+K9wX89ECDplig7od5jVLD9F7G44SRFtataJlmXORCFvoKZCEfXsN4B6Pbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=buryconsultantservice.com;
	spf=fail smtp.mailfrom=buryconsultantservice.com;
	arc=none smtp.remote-ip=202.130.44.230
Received: from out202-230-vmse04.mailcluster.com.au (out202-230-vmse04.mailcluster.com.au [202.130.44.230])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675F4606A31A
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 13:20:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 675F4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=buryconsultantservice.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=buryconsultantservice.com
Received: from sh00074.dp.smartservers.com.au ([116.90.32.86])
	by vmse04.mailcluster.com.au with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <support@buryconsultantservice.com>)
	id 1xMQ3V-00AYmT-JO
	for dm-devel@lists.linux.dev; Fri, 30 Oct 2026 00:20:35 +1100
Received: from lim106.truehost.cloud ([145.239.3.48]:60828)
	by sh00074.dp.smartservers.com.au with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <support@buryconsultantservice.com>)
	id 1xMQ3U-000000008RY-42SB
	for dm-devel@lists.linux.dev;
	Fri, 30 Oct 2026 00:20:33 +1100
From: Loan Consultant <support@buryconsultantservice.com>
To: dm-devel@lists.linux.dev
Subject: Loan offer
Date: Thu, 29 Oct 2026 13:20:32 -0000
Message-ID:
 <179328003221.4030102.7056231625734218347@buryconsultantservice.com>
Reply-To: support@buryconsultantservice.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Authenticated-User: bsharp@kelils.com
X-Authenticator: dovecot_plain
X-SpamExperts-Domain: digipac-sh-outbound8.mailcluster.com.au
X-SpamExperts-Username: 116.90.32.86
Authentication-Results: mailcluster.com.au; auth=pass smtp.auth=116.90.32.86@digipac-sh-outbound8.mailcluster.com.au
X-SpamExperts-Outgoing-Class: unsure
X-SpamExperts-Outgoing-Evidence: Combined (0.65)
X-Recommended-Action: accept
X-Filter-ID: 9kzQTOBWQUFZTohSKvQbgI7ZDo5ubYELi59AwcWUnuV7ArdzTBF7roE1dR0ToJcUiObgXL0WEsT3
 g5VgO1SEpyu2SmbhJN1U9FKs8X3+Nt3uG03lT3HXOS+61P2frUBtgYbIeq91fhUOUweyJiWylt+4
 9mIzG34pQwX9wNQunZuRuadCwwU7MyWIINFYebV2vmCxN3kuXp5VzgZ26Dl6IArZqEIWNsawW/Av
 rVlL6q6gSrEnYb3fyebF+XWmY5GL5Jl1E7MMuTIBkHKu0QRiGc7Yc9LzZDl/BJuHI+g/8HV/zEhP
 hDec8R03E7AFnGT60MxOKVrDfQzDgqFDumjx967VZqJmzCeHtqZ+QtMgTB13guhadlHkux/su5aC
 0xs45Oj564+e6R2rCFo8ZeVUGgpEGVvNbTBAUOGwJ9Lg6yfbhkbij69AW/2LjxMfMQqfn2I7Oqjk
 GFLe+osA9Pqag906UBc89/7GJ6vCcz+zUckzAbly6dvQLN/501YSuV9YXijgKVMZ3rsRCAB1U7+1
 eOWBOXp8nHKe0R+FkIqN7hmWJHQUployr7w/Ej+v3l0AFe9OCuncHzwLztl2wKWmLBR9Ovbqz/k9
 Jlx8RTZkJCvyUT8InQIFBuNsgjEbfWwVEo6Fw5tldaeQTD7oX0IbJuAoo3wRmO0ms/UvYQ1GikEw
 HlEuQVuYCr/QRe04GaBn5PvHiO18zkU9oNPqkAKZ4ZA8y7HoHiH+Y0eTzU5RekV/EVFTjI6pTY8p
 IffNNxiVxRp8tHMI3PD7hU0csE2GwNEyNZWVFHR8KzCX3koJAFemvfweviSx6lkX58I4aVLFK+eJ
 Ia3QQaIyBJFHBSzOpcY7WWit8f0fP54kkuavTL8Vx+BHeBz//TYHrE9rbKQ1MoFFuKyCxDRrKvw/
 y7iZ+/BL7qxtdzaAW4yWXtAkuf1Pcm7P/DUkIuXKXfJy3i2CDLHZNAWsBw+Y2NrUUP4NOn6m+UeF
 XprlCOm3BAEbJtCNbjgywPngiPgpTvX+OpekCJOcJ3N8t1+07MvbA9htcauKqKJXBeH3epFwi2tN
 OOa1x8NTSDIZsJbE9YCEyU6NYv28I509CrOhpMw3BSLgJ36/Bpi3RPbwnfltmdYhsM69D0oR4Nt3
 NsPNkcWC6/aSWPiFbmX0VV8n4s1FTwO2NLPXJxEWrh9wIMuQP9hYdtk=
X-Report-Abuse-To: spam@vmse01.mailcluster.com.au
X-Complaints-To: abuse@vmse01.mailcluster.com.au

Looking for business financing? We offer loan options designed to support bus=
iness growth and help with your financial needs. Contact us today to learn ab=
out available amounts, interest rates, eligibility, and repayment terms. Appl=
y now to get started!

Loan Consultant, uk
Not interested? Just reply and say so, and I won't email you again.
