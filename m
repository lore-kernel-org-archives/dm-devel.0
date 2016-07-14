From: Michal Hocko <mhocko@kernel.org>
Subject: Re: System freezes after OOM
Date: Thu, 14 Jul 2016 17:31:20 +0200
Message-ID: <20160714153120.GD12289@dhcp22.suse.cz>
References: <57837CEE.1010609@redhat.com>
 <f80dc690-7e71-26b2-59a2-5a1557d26713@redhat.com>
 <9be09452-de7f-d8be-fd5d-4a80d1cd1ba3@redhat.com>
 <alpine.LRH.2.02.1607111027080.14327@file01.intranet.prod.int.rdu2.redhat.com>
 <20160712064905.GA14586@dhcp22.suse.cz>
 <alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com>
 <20160713111006.GF28723@dhcp22.suse.cz>
 <alpine.LRH.2.02.1607131021410.31769@file01.intranet.prod.int.rdu2.redhat.com>
 <20160714125129.GA12289@dhcp22.suse.cz>
 <740b17f0-e1bb-b021-e9e1-ad6dcf5f033a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <740b17f0-e1bb-b021-e9e1-ad6dcf5f033a@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Kozina <okozina@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jerome Marchand <jmarchan@redhat.com>, Stanislav Kozina <skozina@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu 14-07-16 16:08:28, Ondrej Kozina wrote:
[...]
> As Mikulas pointed out, this doesn't work. The system froze as well with the
> patch above. Will try to tweak the patch with Mikulas's suggestion...

Thank you for testing! Do you happen to have traces of the frozen
processes? Does the flusher still gets throttled because the bias it
gets is not sufficient. Or does it get throttled at a different place?
-- 
Michal Hocko
SUSE Labs
