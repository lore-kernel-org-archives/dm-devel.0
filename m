Received: from c2682.mx.srv.dfn.de (c2682.mx.srv.dfn.de [194.95.239.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430AF22A1CD
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 13:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.95.239.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741614805; cv=none; b=qgKpgIzv0ANuqlWMkLNJhIktO/a9TTZLlxOTMP9T+O42DC2msOqdXJ26Q4rSMQUxmphNMfjY6nz3g4qFhfMkUSx+/TtJVWpS9xDmAWcWSWWGQptvYNHwCScrbJYWXyvNUcqgs4UEvzDlSdR6QasRdLmejq7HBB6+k1rJqFWIBhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741614805; c=relaxed/simple;
	bh=qY+EkoGgE3SHVgE2VZ99bYenPf/cyMiSFWGbS7N5vzo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=LJUmQuRbYXmGAM76OT+GDEk0w9Q+h0wExZzTtSLggRIPvZGyBIMLdaagirdhE7xsfVIgBOtIN8WExAWF+eniqSXmpizxtegXScdJSn5Y3IjZf2O0+BxVz9ye9FtPRw05W1NrbJR3KN7Lm1UiZDY4zPY61EwhID+sLzuwMheeUTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stud.tu-darmstadt.de; spf=pass smtp.mailfrom=stud.tu-darmstadt.de; dkim=pass (1024-bit key) header.d=stud.tu-darmstadt.de header.i=@stud.tu-darmstadt.de header.b=3FmYzWox; arc=none smtp.client-ip=194.95.239.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stud.tu-darmstadt.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stud.tu-darmstadt.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stud.tu-darmstadt.de header.i=@stud.tu-darmstadt.de header.b="3FmYzWox"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
	stud.tu-darmstadt.de; h=content-transfer-encoding:content-type
	:content-type:content-language:subject:subject:from:from
	:mime-version:date:date:message-id:received; s=s1; t=1741614286;
	 x=1743428687; bh=qY+EkoGgE3SHVgE2VZ99bYenPf/cyMiSFWGbS7N5vzo=; b=
	3FmYzWoxzngXwJpDfPHvbTM01zGygZ5UlCiv29GoIKNP2Q8QrDy1gjF20JARiyIA
	0eXIPIxTSFyyIvDHCr202WBQEIapLj6BCpb+JdH81kh1jZM3EdxTa+uKY8Rlx58w
	a84fEQhGKGO5x/IoE+6akXf5w3g5xJex0NYhF2lpq8k=
Received: from mail-relay150.hrz.tu-darmstadt.de (mailout.hrz.tu-darmstadt.de [IPv6:2001:41b8:83f:1611::150])
	by c2682.mx.srv.dfn.de (Postfix) with ESMTPS id D7B1977D
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 14:44:46 +0100 (CET)
Received: from smtp.tu-darmstadt.de (mail-relay238.hrz.tu-darmstadt.de [130.83.156.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits)
	 client-signature RSA-PSS (4096 bits))
	(Client CN "mail-relay238.hrz.tu-darmstadt.de", Issuer "Sectigo RSA Organization Validation Secure Server CA" (not verified))
	by mail-relay150.hrz.tu-darmstadt.de (Postfix) with ESMTPS id 4ZBJ6P5q8mz44V8
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 14:44:45 +0100 (CET)
Message-ID: <d8814962-6f31-48bf-b82c-0f83d7486c32@stud.tu-darmstadt.de>
Date: Mon, 10 Mar 2025 14:44:44 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: jonathan witt <jonathan.witt@stud.tu-darmstadt.de>
Subject: [RFC] DM-Verity: Proposal to add a pcr_extend(blk_no) upon detecting
 a mismatch
To: dm-devel@lists.linux.dev
Content-Language: en-US
Autocrypt: addr=jonathan.witt@stud.tu-darmstadt.de; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Header-TUDa: <dAcuOwa4Vq1lmHArgFWhnnQc5uLCcm4b9w0XfFIEE75K7sncOPBHaotyjU27RkLyKiQQOMbF95c5CzS58J0uSFjy1rSZ.1741614286>

Hello all,

Intended change:

     When a corrupted block is detected on a verity device, when 
calculating the hash of a block, which is unequal to the 
verity_io_want_digest, (dm-verity-target.c@563) in which case the 
verity_handle_data_mismatch function logs the number of the affected block.

The change could look similar to this sketch starting from 
dm-verity-target.c@486

          dm_audit_log_bio(DM_MSG_PREFIX, "verify-data", bio, blkno, 0);

#ifdef CONFIG_TCG_TPM    //Could also check if flag is set for this 
feature in verity's invocation
         chip = tpm_chip_alloc();
         tpm_pcr_extend(chip, PCR_VERITY_ERROR, blkno);

         // Which of the 24 PCR to use can be decided later. As far as I 
know 0-7 is reserved for Firmware and 8-15 for Kernel or systemd 
features etc.
         dev_err(dev, "%s: tpm_chip_alloc failed\n", __func__);
#endif
          return -EIO;

The reasoning:

In light of the surge of TPMs used in other Operating Systems or systems 
in general, it would be great to integrate the option of working with a 
TPM in as many areas as possible in the system. This change specifically 
has quite a few useful benefits for secure system design.

To put it concisely, currently DM-Verity does not have a whole lot of 
options in regards to dealing with corruption. Panic or restart is 
rarely a viable option for most systems, while logging itself does not 
have any impact on the security, unless the logs are used for further 
investigation / threat analysis. It is that which would be greatly 
enhanced if verity would also directly log to a TPM when configured. 
This would open up verity to a wide range of possibilities for dealing 
with corruption, for example local investigation into the criticality of 
the corruption / tying access rights managed by the TPM to which block 
has been corrupted (e.g user vs root directories etc.) but also remote 
attestation, sending the corrupted blocks to a central IDS-like service 
to analyse which parts exactly have changed and weather this was a 
deliberate attack or perhaps a hardware/software malfunction.

Lastly there is also a second section in the code where a verity error 
is logged. In dm-verity-target.c@362 in the verity_verify_level 
function, as far as I can tell, the whole metadata block is logged. I 
would like to ask for some feedback, weather this would also be a good 
candidate to be captured in the TPM.

Thank you for reading.

--

Jonathan Witt

