Received: from mail.tnxip.de (mail.tnxip.de [49.12.77.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE012744E
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 10:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.77.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746614779; cv=none; b=S6ZyqwjnhKX4ZMbAkNYvwa3UY5rRPWd0njUjZXjt8vmocsiNCjGbnh6ZQkydXJCrQK0+R7uyPWe2L7hzkNVtZYzfn156WIHJp9hunLMXFjl4YYAxBhCUCPBDW+JVJl0gQvMsSRLT5oPFt1PYzgjtBbdK3CGoaenHSXYDwxVGwKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746614779; c=relaxed/simple;
	bh=JWATYdGUi08rRW7zEx6g7PkfpocjtZURQETGGVg3PSU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=DfZ1/EseBdK3N8fq6xFrjRH+6uAHJDojYG71nSX5V0CcWRE4LiCDnosHwoLpp0Yy3x7lxZbA2GAdPW4AifunxDJAysTIe1JU3MQbffAsAWOFKFKbqecPAqpwKwhbci3etEN6wCZAUQ9z7icNP6AqxUa4CiwOLytcKS480kU4dRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de; spf=pass smtp.mailfrom=tnxip.de; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=HwbA/OB4; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=llRUPB0F; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=HOx0i4t0; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=gL1uNmqP; arc=none smtp.client-ip=49.12.77.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnxip.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="HwbA/OB4";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="llRUPB0F";
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="HOx0i4t0";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="gL1uNmqP"
Received: from gw.tnxip.de (unknown [IPv6:fdc7:1cc3:ec03:1:236:8155:1bb8:b14])
	by mail.tnxip.de (Postfix) with ESMTPS id 8D28E208AB;
	Wed,  7 May 2025 12:41:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-vps;
	t=1746614461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JWATYdGUi08rRW7zEx6g7PkfpocjtZURQETGGVg3PSU=;
	b=HwbA/OB4lW0OT7ut6s0HKiM1Fskjgx/3ByfDhdibxQuYNJzet33U0lBhulJGy3kRXkz3Gf
	rD2c+SS5zTP60gBpXfI0f+Ii2UlkxS6wDUeJ9ubW4NiDe8HbiTfXlg9MySTFNs5igmNglA
	L6b6GdU2W8n17wI1qkWvwhl/I/qHu9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-vps-ed; t=1746614461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JWATYdGUi08rRW7zEx6g7PkfpocjtZURQETGGVg3PSU=;
	b=llRUPB0FZjrKpwguz+p8gTtGaGJyS/Yb2sdQapCs32mkCwT86GGDaUWZbtVcyUqZy8BYn/
	LLdvQiP/fjjx3EAA==
Received: from [192.168.1.99] (_gateway [192.168.1.10])
	by gw.tnxip.de (Postfix) with ESMTPSA id 0597EF000000000000C76;
	Wed, 07 May 2025 12:40:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-gw;
	t=1746614461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JWATYdGUi08rRW7zEx6g7PkfpocjtZURQETGGVg3PSU=;
	b=HOx0i4t0kkGiiycNPDlRy4QCNy+6ssfwiQl4VmleuBD/Wjdwovp38i6hyEjpbDYFp/GWUH
	6lcmwFmwSKvBAeyrtUgU8E65fNdEqqSYIlT0avfatmGYuH/hArz0c7CNXQDaZx7u+U1qzw
	Kw6xgaAf0ClT8mi25b3ccUY7Q9YJ8p0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-gw-ed; t=1746614461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JWATYdGUi08rRW7zEx6g7PkfpocjtZURQETGGVg3PSU=;
	b=gL1uNmqPRzDMXeZylqp3rb3n5bR4tp4X9hlYQ6+tdxlwn0yXzO/Xm4m/t0YPzV8bmTI6Rl
	cWg6V0GbjOmmIvCg==
Message-ID: <fc8148d9-4b9f-4c13-9924-2f9b0eced194@tnxip.de>
Date: Wed, 7 May 2025 12:40:54 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Content-Language: en-US, de-DE
To: bmarzins@redhat.com, dm-devel@lists.linux.dev
From: =?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>
Subject: LVM RAID1 regression in 6.15-rc5, bisected
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

kernel 6.15-rc5 fails to access lvs which use mirroring (lvcreate -m1).
Last working release is -rc4. Reverting
5a2a6c428190f945c5cbf5791f72dbea83e97f66 fixes the issue.

Output of "lvs" when broken:

  /dev/mapper/vg_nvme-wine_games: open failed: No such file or directory
  Expected raid segment type but got NULL instead.
  WARNING: RaidLV vg_nvme/wine_games needs to be refreshed!  See
character 'r' at position 9 in the RaidLV's attributes and also its
SubLV(s) with option '-a'.
  Expected raid segment type but got NULL instead.
  LV          VG      Attr       LSize   Pool Origin Data%  Meta%  Move
Log Cpy%Sync Convert
  civ4pitboss vg_nvme rwi---r--- 
15.00g                                                    
  lv_bcfs0    vg_nvme -wi-ao----
768.00g                                                    
  lv_bcfs1    vg_nvme -wi-ao----
768.00g                                                    
  lv_swap0    vg_nvme -wi-ao----  
8.00g                                                    
  lv_swap1    vg_nvme -wi-ao----  
8.00g                                                    
  mariadb     vg_nvme rwi---r--- 
32.00g                                                    
  win10_games vg_nvme rwi---r--- 
40.00g                                                    
  wine_games  vg_nvme rwi-XXr-r-  15.00g           


Output of "lvs" with 5a2a6c428190f945c5cbf5791f72dbea83e97f66 reverted:

  LV          VG      Attr       LSize   Pool Origin Data%  Meta%  Move
Log Cpy%Sync Convert
  civ4pitboss vg_nvme rwi-a-r--- 
15.00g                                    100.00          
  lv_bcfs0    vg_nvme -wi-ao----
768.00g                                                    
  lv_bcfs1    vg_nvme -wi-ao----
768.00g                                                    
  lv_swap0    vg_nvme -wi-ao----  
8.00g                                                    
  lv_swap1    vg_nvme -wi-ao----  
8.00g                                                    
  mariadb     vg_nvme rwi-aor--- 
32.00g                                    100.00          
  win10_games vg_nvme rwi-a-r--- 
40.00g                                    100.00          
  wine_games  vg_nvme rwi-a-r--- 
15.00g                                    100.00          


Hope this helps.

Regards

Malte

