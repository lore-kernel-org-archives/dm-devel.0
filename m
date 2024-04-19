Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6353013C3F9
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 19:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713553942; cv=none; b=XEUbATXsI2qx+QbfxRS59yJ4vlqez890+qDVcfnVGgA2OUY1C5QBRuCayq7DL1+fygDgj63Aud3sZU8FkRlP27T3cILLEevVHQuOtRPbyOe5zjrwDnvInDG9c9C3TA4ACTwSgvbMYg9qK14yNKXUWSzgAvhQI6vZ32ZlAh6CzjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713553942; c=relaxed/simple;
	bh=gPMTOgsIIQ7eBofXxb/LsEVAm7B7MrqNibZ1nIsfb+Q=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=HkXwlPmuN+q81sfUSz1SujhKDl4+Kri/n5gEot0q3nJVdVQ3mdTUQ8B2hUdzXwapxE0XUvC4NC67wTDUpV19vM69gsdq9rTsEpv4c2Av3Q1mEeVq8929nOEfpTji0eZ5LiqhWFTaPZqnMhJ6BVh5wm7rguP3YLHSvIrJtsFEJ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=owlfolio.org; spf=pass smtp.mailfrom=owlfolio.org; dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b=JYbHzcJ7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=K73Y9NFL; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b="JYbHzcJ7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="K73Y9NFL"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 6F0C411400F6;
	Fri, 19 Apr 2024 15:12:19 -0400 (EDT)
Received: from imap45 ([10.202.2.95])
  by compute5.internal (MEProxy); Fri, 19 Apr 2024 15:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=owlfolio.org; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1713553939; x=1713640339; bh=cvbhxXu+Me
	nvJbOn0CMV5ydqUayWSUJGMilVEkeT5U0=; b=JYbHzcJ7h4t7aaudnz0hvhfTUH
	do5GaV7DeRsZ7OP9RDymUuYZxZjq+oH74dxUyYXyo45GsZYgwbXpqdbadN1ZQPtx
	dPcv7SMl4p/4iripl7g3KDD31j4R2Ub1gWzYle1rUEnVduWsl0YmJzvqjWH9bvMX
	VjzEjLVq1pN4I7gifyEjsIyJSurG3ptKI48BHFkGQ6W/kA3PKhFNW6mPg7d3Pvw/
	BHcUbf0TwEj4JDeECETy/WHhi9GjHT8D8sm6hupktDzzOh6esPnHJWLkqt6XJTrz
	LtHYMJfn73DakoXZa/pyRmcyQAEgzZH8mWbug8RN+epJ8Wp3lXmguC+RBPeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1713553939; x=1713640339; bh=cvbhxXu+MenvJbOn0CMV5ydqUayW
	SUJGMilVEkeT5U0=; b=K73Y9NFLOUF5N4QpUAFVl7mDoJltkokMkcBwiGyi41mT
	kCn5F5YnvPBV11chGvv1EzXFNc6a+riEEW0HFEo9m3qgKsnLa7CKhd+G0pkVntpD
	5ZhhzwhgCQSB9VxvsIRLrKZBUeTdLXGglqVrGHNUyBnym1u7Llzna4mE3Fpq6gik
	6vk44goEPj3ymwG6rLCOfBPdi/SCrv1yACoQCUINZM15eYgomQhytoNDU0Q/a7RN
	rDH06HjfSbrHBAM7tR15WzCSkc/odWrwJUcilHlbS6KKs2PYtMCrnAqMhkPJHtg0
	9i3+6irBYSpBrM++uJlrqyenAebVnOLbH0gaP+2Xhw==
X-ME-Sender: <xms:E8IiZsh7uPkRtdu8z2u3IK7Va2V7uIQrmy8xiqMlf6vg8IpBKpJ12g>
    <xme:E8IiZlCAGOfKbpMCvjLfvkJ9t8SIGXYOY3j00g1gHKaFL3cTRfirG-QTC8Dop5RVd
    0eHADLOm6wylNOsmE4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudekvddgudefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdgk
    rggtkhcuhggvihhnsggvrhhgfdcuoeiirggtkhesohiflhhfohhlihhordhorhhgqeenuc
    ggtffrrghtthgvrhhnpefhleefheduhfelgeehgeejveehueeihedvgfeuueetteelieei
    teehfefhleduieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpeiirggtkhesohiflhhfohhlihhordhorhhg
X-ME-Proxy: <xmx:E8IiZkHa1gnuFbUgAxp-XPNEpou4NZwCEVvj61enkgHoWSscSbHlYQ>
    <xmx:E8IiZtS_YA9DznpwHX2L02MedGPG2z1i8Baku6V-iXQPACAa4KaHqg>
    <xmx:E8IiZpzpPWSEhLWzJtntY4OapV9cjX39J9i44SAzKE7jgQ1NRqSLiA>
    <xmx:E8IiZr479XKnfeyy1JL4TXwvupI3sH3tCtK5kiKxMOHDVt9TMrtdDA>
    <xmx:E8IiZgnVZKrhEjlJLzRkRmtd1GtrRnrPQr0AZlNF588991E_gvk3aGdO>
Feedback-ID: i876146a2:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 101A9272007C; Fri, 19 Apr 2024 15:12:18 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-379-gabd37849b7-fm-20240408.001-gabd37849
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <a2369edc-7159-4f0d-8f89-9d41a79d7f7e@app.fastmail.com>
In-Reply-To: <ae79e84e-5a69-dc3a-08da-ef03f6d17c34@ispras.ru>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
 <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com>
 <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com>
 <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
 <e35dccca-a1e7-93c4-f797-b89246877370@redhat.com>
 <9cefd07d-2940-4865-bd77-3dd0899a539f@cs.ucla.edu>
 <d387436c-8c35-4f51-bf49-dc02d829c73a@app.fastmail.com>
 <ae79e84e-5a69-dc3a-08da-ef03f6d17c34@ispras.ru>
Date: Fri, 19 Apr 2024 15:11:51 -0400
From: "Zack Weinberg" <zack@owlfolio.org>
To: "Alexander Monakov" <amonakov@ispras.ru>
Cc: "Paul Eggert" <eggert@cs.ucla.edu>,
 "Mikulas Patocka" <mpatocka@redhat.com>, "H . J . Lu" <hjl.tools@gmail.com>,
 "GNU libc development" <libc-alpha@sourceware.org>,
 "Zdenek Kabelac" <zkabelac@redhat.com>, "Ondrej Kozina" <okozina@redhat.com>,
 "Milan Broz" <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
Content-Type: text/plain

On Fri, Apr 19, 2024, at 2:53 PM, Alexander Monakov wrote:
> On Fri, 19 Apr 2024, Zack Weinberg wrote:
>
>> On Fri, Apr 19, 2024, at 2:45 PM, Paul Eggert wrote:
>> > On 4/19/24 11:04, Mikulas Patocka wrote:
>> >> There's already "explicit_bzero", so maybe we could add
>> >> "explicit_memcpy"
>> >
>> > Where would this stop? Wouldn't we also need explicit_memcmp, 
>> > explicit_memmove, explicit_mempcpy, etc.? Pretty much any function that 
>> > looks at memory could have the problem. Even C source code that doesn't 
>> > invoke any C library function could have the problem.
>> 
>> As I recall, one of the arguments for _not_ adding explicit_bzero to glibc
>> was that we couldn't guarantee copies of the secret data wouldn't hang
>> around in registers.
>
> bzero and memset have no reason to read data from memory, they only need
> to overwrite that memory. This makes them different from memcpy.

Yes, but the compiler does not know that bzero/explicit_bzero/memset only write
and do not read, which means if you have something like

void aes256_encrypt_in_place(const uint8_t *key, const uint8_t *iv,
                             uint8_t *data, size_t len)
{
    __m128 round_keys[AES256_N_ROUND_KEYS];
    aes256_expand_key(key, round_keys);
    aes256_do_cbc(round_keys, iv, data, len);
    explicit_bzero(round_keys, sizeof round_keys);
}

and aes256_expand_key and aes256_do_cbc get inlined, the compiler might
be able to keep the entire key schedule in the vector registers *until*
the call to explicit_bzero.  But right before calling explicit_bzero,
it will have to copy the round_keys array onto the stack!  And the copy
of round_keys in the vector registers *won't* get erased -- the exact
problem being discussed in this thread.

>> Is a hypothetical function __attribute__((clear_call_clobbered_regs_on_exit))
>> what we need here instead, maybe?
>
> As indicated upthread, there's a non-hypothetical
> __attribute__((zero_call_used_regs)), unless you mean something else?

I didn't know whether "call used" meant what I mean by "call clobbered".
Also, it's not clear to me whether this is bulletproof (under whatever name).

zw
