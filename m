From: James Morris <jmorris@namei.org>
Subject: Re: [RFC PATCH v3 05/12] fs: add security blob and hooks for
 block_device
Date: Thu, 23 Apr 2020 02:42:49 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.2004230234420.12318@namei.org>
References: <20200415162550.2324-1-deven.desai@linux.microsoft.com> <20200415162550.2324-6-deven.desai@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200415162550.2324-6-deven.desai@linux.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: deven.desai@linux.microsoft.com
Cc: agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, "Serge E. Hallyn" <serge@hallyn.com>, zohar@linux.ibm.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, jannh@google.com, tyhicks@linux.microsoft.com, pasha.tatashin@soleen.com, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, nramas@linux.microsoft.com, mdsakib@linux.microsoft.com, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Stephen Smalley <sds@tycho.nsa.gov>, Chad Sellers <csellers@tresys.com>, John Johansen <john.johansen@canonical.com>
List-Id: dm-devel.ids

On Wed, 15 Apr 2020, deven.desai@linux.microsoft.com wrote:

> From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> Add a security blob and associated allocation, deallocation and set hooks
> for a block_device structure.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>

Is there any feedback from block or LSM folk on the addition of a security 
blob for block_device here?

IPE uses this is to track the status of integrity verification of e.g. 
DM-Verity devices, per this code from a subsequent patch:


+       ret = security_bdev_setsecurity(dm_table_get_md(v->ti->table)->bdev,
+                                       DM_VERITY_SIGNATURE_SEC_NAME,
+                                       v->sig->sig, v->sig->sig_size);


-- 
James Morris
<jmorris@namei.org>
