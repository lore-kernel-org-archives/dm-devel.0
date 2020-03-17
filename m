From: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] dm verity fec: Fix memory leak in
 verity_fec_ctr
Date: Tue, 17 Mar 2020 10:04:16 -0700
Message-ID: <1584464656.4545.15.camel@HansenPartnership.com>
References: <5e70da92.1c69fb81.c30ac.5d5cSMTPIN_ADDED_BROKEN@mx.google.com>
	<CABCJKuf6X6fi8fqF_z0HYX0rnD8b98=L-8Y31=OiPEVzw0d1_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABCJKuf6X6fi8fqF_z0HYX0rnD8b98=L-8Y31=OiPEVzw0d1_Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sami Tolvanen <samitolvanen@google.com>, "Shetty, Harshini X (EXT-Sony
	Mobile)" <Harshini.X.Shetty@sony.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "Takeuchi,
	Shingo (SOMC)" <Shingo.Takeuchi@sony.com>, "Nagaraju,
	Srinavasa (SOMC)" <Srinavasa.Nagaraju@sony.com>, "Khasnis,
	Soumya X (EXT-Sony Mobile)" <Soumya.Khasnis@sony.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Takahashi,
	Masaya (SOMC)" <Masaya.Takahashi@sony.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

You two broke threading on this for what looks like non-trivial
reasons.  Threading is becoming very important to us with the mbox
tools, so it's important to get right.

The original problem is that the first message id is illegal under RFC
2822:

> Message-Id:	<20200317091212.GA18241@harshini.x.shetty@sony.com>

You can't have two @ signs in a Message-id.  However, your emailer
completely made up the in-repy-to id which should quote the original
message id:

> References: <5e70da92.1c69fb81.c30ac.5d5cSMTPIN_ADDED_BROKEN@mx.google.com>
> In-Reply-To: <5e70da92.1c69fb81.c30ac.5d5cSMTPIN_ADDED_BROKEN@mx.google.com>

Which is why threading broke.

Can you both try to fix this?  The google problem looks to be atypical
because if I look at any other mailer behaviour it will simply quote a message-id back in the In-Reply-To without checking for legality.

James
