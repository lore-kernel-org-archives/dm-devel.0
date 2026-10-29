Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.130.44.230
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793283678;
	b=sKr/fJycL+RtRjRzeZaeaxX76U5CV+7IxUIz0RR+dQqlO5DSUjQ2bFvSd+kD2sR02mCY
	 /uT+du0MDj48yB1/4jP337gwPr+bfXZaRmYQLxZOTjHZr01wR8pkeFdJVTuuYO+jTleU/
	 oqt2D2tb3wXtNO7+fhT+Q38EIBsdYBLuS6JfR2AFq9sd6VowAFwMQsVDGy8wr/AV8B3P5
	 glVrE+8BY7zKTU4yGNrAhS5RBW8+rR8zEsSFpWwmTKO3/pO8sEfu/BT26AfJkaivB52BQ
	 J70v6hMNRVKp07xM4+mbhLIPgAKbN8odwXYHVxraXXE++TxPcLkrOrEG6wdlC2+fzFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283678;
	h=DMARC-Filter:Received:Received:From:To:Subject:Date:Message-ID:
	 Reply-To:Content-Type:Content-Transfer-Encoding:MIME-Version:
	 X-Authenticated-User:X-Authenticator:X-Originating-IP:
	 X-SpamExperts-Domain:X-SpamExperts-Username:
	 X-SpamExperts-Outgoing-Class:X-SpamExperts-Outgoing-Evidence:
	 X-Recommended-Action:X-Filter-ID:X-Report-Abuse-To:X-Complaints-To;
	bh=pWpBIbE1tpakQFXOiqC33gk1ji50hFVwpLCEgZ+UptI=;
	b=KYbPU0k8Rx/T+D5Fc5gUfn2+ql60UNzc6rdroSsYSVWv1ckwdVOsXGeyhK4TGM3w6ZVV
	 RMWxvpb0ZI0WHS3xNKKPaD/Y03fOCRi021XbfThXIypUU3/5148Qj+9eryGvEbqSZvUei
	 lxN8o1hk8MbFeg7GoxcWXDbnNfmsZ2ZZAisTJ9m+qvQ75FVmAwP6PTLxGn9J85o/xudFH
	 Dkumn1LKnCVMJVJz0VS9dq7Inaqy+ebxq4Fcro6wvvpcVXywNjHjj3L6mChtVhVnLlzQW
	 UxGhcSgza2A0IWA+Ibzd2NsTwFZMAb829j8DVOauLNVElYG6oI9CgVw4dn4avQnb5MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=buryconsultantservice.com;
	spf=fail smtp.mailfrom=buryconsultantservice.com;
	arc=none smtp.remote-ip=202.130.44.230
Received: from out202-230-vmse04.mailcluster.com.au (out202-230-vmse04.mailcluster.com.au [202.130.44.230])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD66606A325
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 14:21:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFD66606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=buryconsultantservice.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=buryconsultantservice.com
Received: from sh00074.dp.smartservers.com.au ([116.90.32.86])
	by vmse04.mailcluster.com.au with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <support@buryconsultantservice.com>)
	id 1xMR0E-00AzKk-6S
	for dm-devel@lists.linux.dev; Fri, 30 Oct 2026 01:21:16 +1100
Received: from lim106.truehost.cloud ([145.239.3.48]:43760)
	by sh00074.dp.smartservers.com.au with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <support@buryconsultantservice.com>)
	id 1xMR0D-00000000YDm-26zY
	for dm-devel@lists.linux.dev;
	Fri, 30 Oct 2026 01:21:13 +1100
From: Loan Consultant <support@buryconsultantservice.com>
To: dm-devel@lists.linux.dev
Subject: Loan offer
Date: Thu, 29 Oct 2026 14:21:12 -0000
Message-ID:
 <179328367275.235988.10349221616978689489@buryconsultantservice.com>
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
X-Filter-ID: 9kzQTOBWQUFZTohSKvQbgI7ZDo5ubYELi59AwcWUnuVpsU8dQavuKRmdIo2llSsULIGENqUlGnLR
 omzYWFQrBiu2SmbhJN1U9FKs8X3+Nt3uG03lT3HXOS+61P2frUBtgYbIeq91fhUOUweyJiWylt+4
 9mIzG34pQwX9wNQunZuRuadCwwU7MyWIINFYebV2vmCxN3kuXp5VzgZ26Dl6IArZqEIWNsawW/Av
 rVlL6q6gSrEnYb3fyebF+XWmY5GL5Jl1E7MMuTIBkHKu0QRiGc7Yc9LzZDl/BJuHI+g/8HV/zEhP
 hDec8R03E7AFnGT60MxOKVrDfQzDgqFDumjx967VZqJmzCeHtqZ+QtMgTB13guhadlHkux/su5aC
 0xs45Oj564+e6R2rCFo8ZeVUGgpEGVvNbTBAUOGwJ9Lg6yfbhkbij69AW/2LjxMfMQqfn2I7Oqjk
 GFLe+osA9Pqag906UBc89/7GJ6vCcz+zUckzAbly6dvQLN/501YSuV9YXijgKVMZ3rsRCAB1U7+1
 eOWBOXp8nHKe0R+FkIqN7hmWJHQUployr7w/Ej+v3l0AFe9OCuncHzwLztl2wKWmLBR9Ovbqz/k9
 Jlx8RTZkJCvyUT8InQIFBuNsgjEbfWwVEo6Fw5tldaeQTD7oX0IbJuAoo3wRmO0ms/UvYQ1GikEw
 HlEuQVuYCr/QRe04GaBnZkcb6kR33+9P/0VqFL2JcJA8y7HoHiH+Y0eTzU5RekV/EVFTjI6pTY8p
 IffNNxiVxRp8tHMI3PD7hU0csE2GwNEyNZWVFHR8KzCX3koJAFemvfweviSx6lkX58I4aVLFK+eJ
 Ia3QQaIyBJFHBSzOpcY7WWit8f0fP54kkuavTL8Vx+BHeBz//TYHrE9rbKQ1BP3LX149P6dfE9D9
 8KkFok8lRrGWzfdmR5cvQZpK4WNPcm7P/DUkIuXKXfJy3i2CDLHZNAWsBw+Y2NrUUP4NOn6m+UeF
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
