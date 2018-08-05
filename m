From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 17/32] libmultipath: fix tur checker double
	locking
Date: Sun, 5 Aug 2018 15:40:30 +0000
Message-ID: <a275a1d52e54d8f4ded3561d71d63784ddaeb4b8.camel@wdc.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
	<1533157038-3924-18-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4178771690885431877=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-18-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <5A8F9E4FBE6B04468F700A13C5768E0F@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

--===============4178771690885431877==
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <5A8F9E4FBE6B04468F700A13C5768E0F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: 8bit

On Wed, 2018-08-01 at 15:57 -0500, Benjamin Marzinski wrote:
+AD4- I realize that this locking was added to make an analyzer happy,
+AD4- presumably because sometimes ct-+AD4-devt was being accessed while ct-+AD4-devt
+AD4- was held, and sometimes not.  The tur checker locking will be cleaned
+AD4- up in a later patch to deal with this.

Are you perhaps referring to commit 873be9fef222 (+ACI-libmultipath/checkers/tur:
Serialize tur+AF8-checker+AF8-context.devt accesses+ACI-)? Your assumption about how DRD
works is wrong. DRD doesn't care about which mutex or other synchronization
primitives are used to serialize accesses to data that is shared between
threads. All it cares about is that concurrent accesses to shared data are
serialized. I'm afraid that your patch reintroduces the race conditions that
were fixed by commit 873be9fef222. Have you considered to fix this without
removing the locking?

Bart.



--===============4178771690885431877==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4178771690885431877==--
