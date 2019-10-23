From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 45/72] libmultipath: fix -Wsign-compare
 warnings with snprintf()
Date: Wed, 23 Oct 2019 09:11:04 +0000
Message-ID: <427b0092920fc26be91794a5a54cc0ca71183745.camel@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
	<20191012212703.12989-46-martin.wilck@suse.com>
	<34e6fc87-10f6-efd7-c8df-710e56cc1956@acm.org>
	<f895f01df7c429abf4a32a395764513c92ecc3af.camel@suse.com>
	<42e85b61-3f38-af4e-a485-1ba230506d0f@acm.org>
	<690ab1be1dc189c6efebf5fb953f31f9f0341286.camel@suse.com>
	<b4e750e1-ecc1-853d-5582-fae16b3932f0@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b4e750e1-ecc1-853d-5582-fae16b3932f0@acm.org>
Content-Language: en-US
Content-ID: <8935A8793384E1468406C08E23B7F3E6@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Bart,

On Tue, 2019-10-22 at 14:32 -0700, Bart Van Assche wrote:
> I'd like to reiterate that introducing -Wsign-compare seems dubious
> to me.

While I disagree with this general statement, I now realized that
my approach to use (int) casts in this specific patch was indeed wrong,
because it prevents detection of negative snprintf() return values.

I'm going to rework this patch.

Regards,
Martin
