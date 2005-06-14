From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [patch] dm-mpath.c trigger_event race
Date: Tue, 14 Jun 2005 23:07:50 +0200
Message-ID: <20050614210750.GY25295@marowsky-bree.de>
References: <20050613172851.GH17296@marowsky-bree.de>
	<20050614091319.GF25295@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050614091319.GF25295@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 2005-06-14T11:13:19, Lars Marowsky-Bree <lmb@suse.de> wrote:

Well, some conversation with Jens suggests that a call to
flush_workqueue(kmultipathd) is the least ugly choice afterall.

However, I still maintain that the reference counting in DM sucks ;-)

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
