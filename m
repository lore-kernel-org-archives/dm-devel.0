Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FC1249F9
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 02:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737514742; cv=none; b=Vz0T/I1whwRGZ5cOup1v6Vtp3WYgX7SOIAoBdwMFKToPC65nFzzAogOIiC6XN3oUA5qji/dbieDcIEkqRXZMyn/7oyZ/wV5b9ojRDv4xI9ajcdKTqDK/Zx4FxFSYDDDTwva/Pgh+/Uo93LbaRWWfPIMmBiFdtTy8INeqMf6x7os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737514742; c=relaxed/simple;
	bh=cJry+MyVNgn1w4jEfCb1vckFSYpa9AR1TLFn61M3A24=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Q3SjZoTgT9Wyu2AK12iVqR1N9j4uxizlNnKodEpF0XDM8F837KNQoRtfY23lCLXpg7Sqs09XeN7HBAEwr7TOlWM/6Elr/Op4SqBNLlkJRm05CZUUvVWZF0IqbpA+gsZa7cy9pzWVikQzcxX1bB5rVfsb3/0yIGncbqBTKzB6Txc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AjOIEigI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AjOIEigI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737514739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M50CwosJi472KACZ3UXyvkNSPfAAjYlbmYWOnt1cPog=;
	b=AjOIEigIlck5YWuZKLnioR61gw4pH3mHgnDzE4ZiaUDy15lhF1BzUC0RmoiSboNPCuEE5Y
	L2nvnOADgRAJFerqSvxXRfo7THigBu0bk7u3MFS7H/3CMnjEGLDdAr/WxTdFBKDBoHxW+0
	+mHU/69jayNHwq11AQk2ouJ6NsCdo6w=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-KpE4JjqbMUqu3rvUrNVtOg-1; Tue, 21 Jan 2025 21:58:58 -0500
X-MC-Unique: KpE4JjqbMUqu3rvUrNVtOg-1
X-Mimecast-MFC-AGG-ID: KpE4JjqbMUqu3rvUrNVtOg
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b6e1c50ef1so933541285a.2
        for <dm-devel@lists.linux.dev>; Tue, 21 Jan 2025 18:58:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737514738; x=1738119538;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M50CwosJi472KACZ3UXyvkNSPfAAjYlbmYWOnt1cPog=;
        b=S2gcZM5Z2bcQxJB+FZbzueiGU66kj5SFQo1l4tygG8RroMbE7UKd8kojGNKZV94s44
         2jF5IkJvTG9haRUMkcF4EAtMV423XVV45F9QLQQW2nrt2oBUFcfkWGDhG+uvTIh/nipL
         BOQsM+IMWbsIOvc0Yx5G9HwAiFzueSueVy30ZbXhWR5CADI6fUvQEE2FFE4s56Qv6kFX
         PIsu/NMdjUlMwz5i60nWE2M936j3tRmIM6TxD1CFP9yP4uov4+LQiIFKXpfJxEMBWzzq
         IvSL/fHG4liMOqAcaQHmFcbgrKqQIESOmjV+kun8Ge/s8liKcQoTnncd0uBp1uKeJrMt
         DRLw==
X-Forwarded-Encrypted: i=1; AJvYcCWRGYKv4RkK9rgwGscaUmjigyyDZMij39/JzyVboeSB7elo/RGe7glqOXcZz7RlxFEdnKymAWV3DQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YypoF//7Ut3/lsxHTwitzxD9PH8HY9ifMsJcYrFSbfRzpZIfi2c
	JdzVzANMaim69nnOD3viayqXCCAgjxG9aqZbHyhJavF/kvweO9K1H2pTxkwmaCWHBf0IL3lu8Ql
	gaM8peeLUw+9vVGXF1BAjxDpazsRZ8XRNcPDH+FeFKscBuQ22BjzOn4PnSPiEzaW+
X-Gm-Gg: ASbGncvnbb0Xu2mc4IZmombjwbTp4Jun5z/wZxATOpLKGzJesBjPWOlxFhpgqiWBslG
	VPuKFRspWuDjRYf7EmEPakdy0uBR/UHRlEHSrU6vt0AJzyOqNT1eiGOq8QygOi10QX/fwaWvhWt
	8KoyWL5bik+41AXvwNMX5AVK/NMujDk6b+OuIldKUQbaHlNTN1HsnBsGCUerv3xRzoiZ5+wMi0v
	jQ7HkSToKrC7SB+edyrkfv7QI/pPE4vluXLLJ9dB1UppXR6XbQIabIILTqrVh6fw0sXJqg=
X-Received: by 2002:a05:620a:4495:b0:7b6:eed4:694e with SMTP id af79cd13be357-7be6325fb67mr2795058685a.37.1737514738121;
        Tue, 21 Jan 2025 18:58:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6aWAyArHKpgvq3uOgt9j+TT4AZ4YtKxDWYVp8lK3ZAS/vL2nJjBYDmL5YaDY8jN7loScCZA==
X-Received: by 2002:a05:620a:4495:b0:7b6:eed4:694e with SMTP id af79cd13be357-7be6325fb67mr2795057385a.37.1737514737847;
        Tue, 21 Jan 2025 18:58:57 -0800 (PST)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be614d98dbsm623236885a.74.2025.01.21.18.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 18:58:57 -0800 (PST)
Message-ID: <2f847044-fef9-4cfd-95c6-038c07468e0d@redhat.com>
Date: Tue, 21 Jan 2025 21:58:56 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Adding zstd to VDO
To: Anton Gavriliuk <antosha20xx@gmail.com>, dm-devel@lists.linux.dev
References: <CAAiJnjoGn4Jn6O-SWAaAzwNk4DhEiCFUA0Q0X2RLdrHH7NR5qg@mail.gmail.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <CAAiJnjoGn4Jn6O-SWAaAzwNk4DhEiCFUA0Q0X2RLdrHH7NR5qg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ic6Z5cuCPoBJRHrIgbjDD-YHgT4reNlbsSmei5n9iAY_1737514738
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It's a reasonable idea. We've discussed it before but it hasn't been 
particularly high priority. Since VDO is mainly focused on 
deduplication, it's not clear how much it would help to use a different 
compression algorithm, but it shouldn't hurt anything, either.

To make this work we'd want to add a new create-time option to specify 
the compression algorithm to use. Switching algorithms after data has 
been written to the volume could make older compressed data unreadable, 
so we don't want to allow that.

Matt

On 1/18/25 12:53 PM, Anton Gavriliuk wrote:
> What if zstd can be added to VDO as a compression algorithm along with lz4 ?
> 
> It could provide more flexibility for users - faster compression or
> better compression ratio.
> 
> Anton
> 

